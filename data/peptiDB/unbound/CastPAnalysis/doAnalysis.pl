#!/usr/bin/perl
# author: dattias
# Analysis

use strict;

use File::Copy;

my $myPdb = shift;

my $dbDir = "/vol/ek/londonir/CleanPeptiDB/db/";
my $unboundDbDir = "/vol/ek/dattias/PeptideDocking/PlacementProtocol/unbound/unboundSet";
my $castPDataDir = "/vol/ek/dattias/PeptideDocking/PlacementProtocol/unbound/CastPAnalysis/CastPData";

my $dataDir = "data/";
mkdir $dataDir;

# Files
my $classificationFile = "classificationResults.txt";
my $classificationSummary = "classificationSummary.txt";

# Classification
my $NO_POCKET = 0;
my $IN_BIGGEST_POCKET = 1;
my $NEAR_BIGGEST_POCKET = 2;
my $IN_ANY_POCKET = 3;
my $NEAR_ANY_POCKET = 4;
my $NO_POCKET_ANALYSIS = 5;

my %ClassStr = (
	$NO_POCKET => "NO_POCKET",
	$IN_BIGGEST_POCKET => "IN_BIGGEST_POCKET",
	$NEAR_BIGGEST_POCKET => "NEAR_BIGGEST_POCKET",
	$IN_ANY_POCKET => "IN_ANY_POCKET",
	$NEAR_ANY_POCKET => "NEAR_ANY_POCKET",
	$NO_POCKET_ANALYSIS => "NO_POCKET_ANALYSIS"
);

# Parameters
############
# The distance that a pocket atom should be from a peptide residue.
my $distanceFromAtom = 4.0;
# If there are X atoms from a pocket near a peptide residue
# it is said to be near this pocket. 
my $numAtomsNearResidue = 1;
# If there are X residues from the peptide near the pocket
# it is said to be IN this pocket. 
my $precentResiduesNearPocket = 0.8;
my $numAtomPerRasScript = 10;

my $NOT_NEAR_POCKET = 0;
my $IN_POCKET = 1;
my $NEAR_POCKET = 2;

if(defined($myPdb)){
	my $classificationStr = classifySinglePdb($myPdb);
	print $classificationStr;
	exit;
}

opendir(DIR, $unboundDbDir) or die $!;
open(OUT, ">$classificationFile") or die $!;

while (my $file = readdir(DIR)) {

    next if (!($file =~ m/^(....)\.pdb/));
	my $pdb = $1;
	
	my $classificationStr = classifySinglePdb($pdb);
	print OUT $classificationStr;
}

closedir(DIR);
close(OUT);

open(OUT, ">$classificationSummary") or die $!;
	print OUT printClass($NO_POCKET);
	print OUT printClass($IN_BIGGEST_POCKET);
	print OUT printClass($NEAR_BIGGEST_POCKET);
	print OUT printClass($IN_ANY_POCKET);
	print OUT printClass($NEAR_ANY_POCKET);
	print OUT printClass($NO_POCKET_ANALYSIS);
close(OUT);

###########################################################
sub classifySinglePdb{
	my($pdb) = @_;
	
	print "$pdb\n";
	
	my $currCastPDataDir = $castPDataDir."/".$pdb."/";
	
	my $pdbDir = "$dataDir$pdb/";
	mkdir $pdbDir;
	
	my $class = "";
	if(! -e "$currCastPDataDir$pdb.pdb"){
		print "$currCastPDataDir$pdb.pdb\n";
		print "got here-bad\n";
		$class = $NO_POCKET_ANALYSIS;
	}
	else{
		chdir $pdbDir;
		# Create all neccessary files
		copy( "$dbDir$pdb.pdb", "$pdb.pdb" ) or die "Copy failed: $!";
		#copy( "$currCastPDataDir$pdb.pdb", "$pdb.unbound.pdb" ) or die "Copy failed: $!";
		copy( "$currCastPDataDir$pdb.poc", "$pdb.allPocAtoms" ) or die "Copy failed: $!";
		copy( "$currCastPDataDir$pdb.pocInfo", "$pdb.pocInfo" ) or die "Copy failed: $!";
		`cat $pdb.pocInfo | grep -v Molecule | sort -nr -k 5 > $pdb.pocInfo.sorted`;
		chomp( my $biggestPocketNum = `cat $pdb.pocInfo.sorted | head -1 | awk '{print \$3}'` );
	
		open(ALL_POCKET_ATOMS, "<$pdb.allPocAtoms") or die "Open file failed: $!";
		my @biggestPocketLines = grep(/ $biggestPocketNum  POC/, <ALL_POCKET_ATOMS>);
		close(ALL_POCKET_ATOMS);
		open(BIGGEST_POCKET_ATOMS, ">$pdb.biggestPocAtoms") or die "Open file failed: $!";
		foreach my $line(@biggestPocketLines){
			print BIGGEST_POCKET_ATOMS $line;
		}
		close(BIGGEST_POCKET_ATOMS);
		# DONE: Create all neccessary files
	
		$class = findClassification($pdb);
		
		chdir "../../";
	}
	my $classificationStr = $pdb.": ".$ClassStr{$class}." ($class)\n";
	print $ClassStr{$class}."\n";
	
	return $classificationStr;
}

sub printClass{
	my ($class) = @_;
	chomp(my $c = `cat $classificationFile | cut -d" " -f2,3 | sort | grep -c "($class)"`);
	my $str = $ClassStr{$class}." ($class) - $c\n";
	return $str;
}

sub findClassification{
	my ($pdb) = @_;
	
	my $res_biggestPocket = checkIsInPocket($pdb, "$pdb.biggestPocAtoms");
	if($res_biggestPocket == $IN_POCKET){
		return $IN_BIGGEST_POCKET;
	}
	if($res_biggestPocket == $NEAR_POCKET){
		return $NEAR_BIGGEST_POCKET;
	}
	
	my $res_allPocket = checkIsInPocket($pdb, "$pdb.allPocAtoms");
	if($res_allPocket == $IN_POCKET){
		return $IN_ANY_POCKET;
	}
	if($res_allPocket == $NEAR_POCKET){
		return $NEAR_ANY_POCKET;
	}
	return $NO_POCKET;
}

sub checkIsInPocket{
	my ($pdb, $pocResFile) = @_;
	my %pepResHash;
	getPeptideResidues($pdb, \%pepResHash);
	
	my $rasScriptName = "tmp.rasscript";
	my $modelName = "model.pdb";
	# Patterns
	my $selectResidueNearPocket = "select within (%.2f,(%d and *:B and */0)) and */1";
	
	#@residues = keys %pepResHash;
	#print "@residues\n";
	my $numAtomsFoundPerRes = 0;
	my $numResNearPocket = 0;
	
	# create rasmol model
	open(MODEL, ">$modelName") or die $!;
	
	print MODEL "MODEL        0\n";
	open(PDB, "<$pdb.pdb") or die $!;
	print MODEL <PDB>;
	close(PDB);
	print MODEL "ENDMDL\n";
	
	print MODEL "MODEL        1\n";
	open(PDB, "<$pocResFile") or die $!;
	print MODEL <PDB>;
	close(PDB);
	print MODEL "ENDMDL\n";
	
	close MODEL;
	# DONE: create rasmol model

	foreach my $residue(keys %pepResHash){
		$numAtomsFoundPerRes = 0;
		
		# create rassmol script
		open(SCRIPT, ">$rasScriptName") or die $!;
		my $selectionStr = sprintf($selectResidueNearPocket, $distanceFromAtom, $residue);
		print SCRIPT "$selectionStr\n";
		print SCRIPT "show selected\n";
		print SCRIPT "quit\n";
		close SCRIPT;
		
		my @results = `rasmol $modelName -script $rasScriptName -nodisplay`;
		#print "results: @results\n";
		my $error = grep(/Script command line too long!/, @results);
		if($error != 0){
			die "Error: could not run rasmol script: pdb($pdb), script($rasScriptName)\n";
		}
		my @atomsFound = grep(/Chain: .* Group: /, @results);
		$numAtomsFoundPerRes = scalar @atomsFound;
		
		if($numAtomsFoundPerRes >= $numAtomsNearResidue){
			$numResNearPocket += 1;
		}
	}
	
	my $numPepResidues = scalar (keys %pepResHash);
	#print "numPepResidues: $numPepResidues, numResNearPocket: $numResNearPocket\n";
	if($numResNearPocket >= ($numPepResidues*$precentResiduesNearPocket) ){
		return $IN_POCKET;
	}
	if($numResNearPocket > 0){
		return $NEAR_POCKET;
	}
	return $NOT_NEAR_POCKET;
}

sub getPeptideResidues{
	my($pdb, $pepResHash) = @_;
	
	open(PDB, "<$pdb.pdb") or die $!;
	my @lines = grep(/^ATOM .* B /, <PDB>);

	foreach my $line(@lines){
		$line =~ m/ATOM ......  ....... .(....)/;
		my $resNum = $1;
		trim(\$resNum);
		$$pepResHash{$resNum} = 1;
	}
	
	close(PDB);
}

sub getResList {
	my($filename, $resList) = @_;
	
	#my $resStr = "";
	my %foundResidues;
	
	open(ATOMS, "$filename") or die "Open file failed: $!";
	
	foreach my $line(<ATOMS>){
		next if(! ($line =~ m/ATOM.*POC/) );
		#ATOM    146  CA  GLY A  19
		$line =~ m/ATOM ......  (...).(...) .(....)/;
		my $atom = $1;
		my $aa = $2;
		my $resNum = $3;

		trim(\$atom);
		trim(\$aa);
		trim(\$resNum);
		@$resList = (@$resList, "$aa$resNum.$atom");
		#$resStr .= "$aa$resNum.$atom ";
		#if(! exists $foundResidues{$resNum}){
		#	$resStr .= "$aa$resNum ";
		#	$foundResidues{$resNum} = 1;
		#}
	}
	
	close(ATOMS);
	#trim(\$resStr);
	#$resStr =~ s/ / or /g;
	
	#return $resStr;
}

sub trim{
	my($str) = @_;
	$$str =~ s/^\s+//;
	$$str =~ s/\s+$//;
}
