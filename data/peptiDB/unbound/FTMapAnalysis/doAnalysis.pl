#!/usr/bin/perl
# author: dattias
# Analysis

use strict;

my $dbDir = "/vol/ek/londonir/CleanPeptiDB/db/";
my $unboundDbDir = "/vol/ek/dattias/PeptideDocking/PlacementProtocol/unbound/unboundSet/";
my $ftMapDataDir = "ftmapData/";

my $numMatches_geometricalFit = 3;
my $rms_geometricalFit = 0.7;
my $numMatches_approxFit = 4;
my $rms_approxFit = 2.0;

# Classification
my $MULTIPLE_EXACT_FRAGMENTS = 1;
my $SINGLE_EXACT_FRAGMENT_PLUS_APPROX = 2;
my $SINGLE_EXACT_FRAGMENT = 3;
my $MULTIPLE_APPROX_FRAGMENTS = 4;
my $SINGLE_APPROX_FRAGMENT = 5;
my $NO_FRAGMENTS = 6;
my $NO_CLASS = 0;

my %ClassStr = (
	$MULTIPLE_EXACT_FRAGMENTS => 			"MULTIPLE_EXACT_FRAGMENTS",
	$SINGLE_EXACT_FRAGMENT_PLUS_APPROX => 	"SINGLE_EXACT_FRAGMENT_PLUS_APPROX",
	$SINGLE_EXACT_FRAGMENT => 				"SINGLE_EXACT_FRAGMENT",
	$MULTIPLE_APPROX_FRAGMENTS => 			"MULTIPLE_APPROX_FRAGMENTS",
	$SINGLE_APPROX_FRAGMENT => 				"SINGLE_APPROX_FRAGMENT",
	$NO_FRAGMENTS => 						"NO_FRAGMENTS",
	$NO_CLASS => 							"NO_CLASS",
);

# create ras scripts
my $exactFragmentsRasScript = "findExactFragments.rasscript";
my $approxFragmentsRasScript = "findApproxFragments.rasscript";
my $exactFragmentsResults = "exactFragments.out";
my $approxFragmentsResults = "approxFragments.out";

my $classificationFile = "classificationResults.txt";
my $classificationSummary = "classificationSummary.txt";
my $rasmolPdbName = "forRasmol.pdb";

# findExactFragments: geometricalFit
open(EXACT, ">$exactFragmentsRasScript") or die $!;
print EXACT "select within (".sprintf("%.2f", $rms_geometricalFit).",(*:B and */0)) and not (*/0)\n";
print EXACT "show selected\n";
print EXACT "quit\n";
close EXACT;
# findApproxFragments: approxFit
open(APPROX, ">$approxFragmentsRasScript") or die $!;
print APPROX "select within (".sprintf("%.2f", $rms_approxFit).",(*:B and */0)) and not (*/0)\n";
print APPROX "show selected\n";
print APPROX "quit\n";
close APPROX;

opendir(DIR, $unboundDbDir) or die $!;
open(OUT, ">$classificationFile") or die $!;

my $pdb = "";
my $class = $NO_CLASS;

while (my $file = readdir(DIR)) {

    next if (!($file =~ m/^(....)\.pdb/));
	$pdb = $1;
	print "$pdb\n";
	
	if(-e "$ftMapDataDir/$pdb.map.pdb"){
		createMapFileWithoutProtein($pdb);
		
		# create rasmol model
		open(MODEL, ">$rasmolPdbName") or die $!;
	
		print MODEL "MODEL        0\n";
		open(PDB, "<$dbDir/$pdb.pdb") or die $!;
		print MODEL <PDB>;
		close(PDB);
		print MODEL "ENDMDL\n";
	
		print MODEL "MODEL        1\n";
		open(PDB, "<$ftMapDataDir/$pdb.map.clean.pdb") or die $!;
		print MODEL <PDB>;
		close(PDB);
		print MODEL "ENDMDL\n";
	
		close MODEL;
		# DONE: create rasmol model
		#`cat $ftMapDataDir/$pdb.map.pdb $dbDir/$pdb.pdb > $rasmolPdbName`;
		`rasmol $rasmolPdbName -script $exactFragmentsRasScript -nodisplay > $exactFragmentsResults`;
		`rasmol $rasmolPdbName -script $approxFragmentsRasScript -nodisplay > $approxFragmentsResults`;

		$class = findClass();
		print OUT $pdb.": ".$ClassStr{$class}." ($class)\n";
		`rm -f $exactFragmentsResults $approxFragmentsResults`;
		#`mv $exactFragmentsResults $exactFragmentsResults.$pdb`;
		#`mv $approxFragmentsResults $approxFragmentsResults.$pdb`;
		`rm -f $rasmolPdbName`;
		#print $pdb.": ".$ClassStr{$class}." ($class)\n";
	}

}

closedir(DIR);
close(OUT);

open(OUT, ">$classificationSummary") or die $!;
	print OUT printClass($MULTIPLE_EXACT_FRAGMENTS);
	print OUT printClass($SINGLE_EXACT_FRAGMENT_PLUS_APPROX);
	print OUT printClass($SINGLE_EXACT_FRAGMENT);
	print OUT printClass($MULTIPLE_APPROX_FRAGMENTS);
	print OUT printClass($SINGLE_APPROX_FRAGMENT);
	print OUT printClass($NO_FRAGMENTS);
close(OUT);

#############################################################

sub printClass{
	my ($class) = @_;
	chomp(my $c = `cat $classificationFile | cut -d" " -f2,3 | sort | grep -c "($class)"`);
	my $str = $ClassStr{$class}." ($class) - $c\n";
	return $str;
}

sub findClass{
	my $class = $NO_CLASS;
	
	#print "Exact:\n";
	my $exactFragments = findNumFragments($exactFragmentsResults, $numMatches_geometricalFit);
	#print "Approx:\n";
	my $approxFragments = findNumFragments($approxFragmentsResults, $numMatches_approxFit);

	#print "exact $exactFragments, approx $approxFragments\n";

	if($exactFragments > 0){
		if($exactFragments > 1){
			$class = $MULTIPLE_EXACT_FRAGMENTS;
		}
		else{
			if($approxFragments > 1){
				$class = $SINGLE_EXACT_FRAGMENT_PLUS_APPROX;
			}
			else{
				$class = $SINGLE_EXACT_FRAGMENT;
			}
		}
	}
	elsif($approxFragments > 0){
		if($approxFragments > 1){
			$class = $MULTIPLE_APPROX_FRAGMENTS;
		}
		else{
			$class = $SINGLE_APPROX_FRAGMENT;
		}
	}
	else{
		$class = $NO_FRAGMENTS;
	}
	return $class;
}

sub findNumFragments{
	my ($filename, $numMatches) = @_;
	my $numMatchedChains = 0;
	my $numMatchedUnits = 0;
	my $inChain = 0;
	my $currChain = "";

	open(RESULTS, "<$filename") or die $!;
	chomp(my @rasout = <RESULTS>);
	close(RESULTS);
	my @results = grep(/Chain: .* Group: .*/, @rasout);
	foreach my $res(@results){
		if($res =~ m/.*Chain: (.)  Group:.*\((.*)\/.*/){
			my $chain = $1;
			my $hits = $2;
			#print "\tchain $chain, hits $hits\n";
			if($inChain == 1 && $chain ne $currChain){
				$inChain = 0;
			}
			if($inChain == 0){
				#print "numMatchedUnits(switch) $numMatchedUnits\n";
				if($numMatchedUnits > 0){
					$numMatchedChains = $numMatchedChains+1;
				}

				$numMatchedUnits = 0;
				$inChain = 1;
				$currChain = $chain;
			}
			if($hits >= $numMatches){
				#print "numMatchedUnits(in) $numMatchedUnits\n";
				$numMatchedUnits = $numMatchedUnits+1;
			}
		}
	}
	# Check last chain
	if($numMatchedUnits > 0){
		#print "numMatchedUnits(switch) $numMatchedUnits\n";
		$numMatchedChains = $numMatchedChains+1;
	}

	return $numMatchedChains;
}

sub createMapFileWithoutProtein{
	my ($pdb) = @_;
	
	open(FILE, "<$ftMapDataDir/$pdb.map.pdb") or die $!;
	open(FILE_OUT, ">$ftMapDataDir/$pdb.map.clean.pdb") or die $!;
	
	my $inProtein = 1;
	foreach my $line(<FILE>){
		if($inProtein == 1 and $line =~ m/^HEADER crosscluster/){
			$inProtein = 0;
		}
		if($inProtein == 0){
			print FILE_OUT $line;
		}
	}
	
	close(FILE_OUT);
	close(FILE);
}
