#!/usr/bin/perl
# author: dattias
# showResults.pl

use strict;

my $outputMat = $ARGV[0];
my $trainMat = $ARGV[1];
my $resultsDir = $ARGV[2];
my $pdbDir = $ARGV[3];

mkdir $resultsDir;

open(MAT, "<$trainMat") or die $!;
my @trainMatLines = <MAT>;
close(MAT);

open(MAT, "<$outputMat") or die $!;
my @outputMatLines = <MAT>;
close(MAT);

my $inPdb = 0;
my $exampleIndex = 0;

my $pdb = "";
my @pdbLines = ();
my $newPdb = "";

foreach my $line(@trainMatLines){
	chomp($line);
	
	next if($line =~ m/^#/);
	
	if($line =~ m/#PDB (....)/){
		$newPdb = $1;
		
		if($newPdb ne $pdb){
			if($inPdb == 1){
				#print "finishing previous pdb...\n";
				finishPdb($pdb);
			}
	
			$pdb = $newPdb;
			#print "** Starting $pdb\n";
			$inPdb = 1;
			
			open(PDB, "<$pdbDir/$pdb.pdb") or die $!;
			@pdbLines = <PDB>;
			close(PDB);
			
			for(my $j = 0; $j < scalar @pdbLines; $j++){
				# set b-factor to 0.00
				$pdbLines[$j] =~ s/^(.{60})......(.*)/$1  0.00$2/;
			}
		}
		if($inPdb == 1){
			if($line =~ m/#.*Res (...)(.*)/){
				my $resName = $1;
				my $resNum = $2;
				
				getResLinesStringFromClassification($resName, $resNum);
			}
		}
		
	}
}

finishPdb($pdb);

##########################################################
sub finishPdb{
	my ($pdb) = @_;
	
	my $resultPdb = "$resultsDir/$pdb.results.pdb";
	
	open(RES, ">$resultPdb") or die $!;
	my $str = join("", @pdbLines);
	print RES "$str\n";
	close(RES);
	
	printPmlScriptForPdb($pdb, $resultPdb);
	
	#print "** Done with $pdb\n";
}

sub printPmlScriptForPdb{
	my ($pdb, $resultPdb) = @_;
	
	my $pmlScript = $resultPdb;
	$pmlScript =~ s/.pdb$/.pml/;
	
	open(OUT, ">$pmlScript") or die $!;
	
	print OUT "load $pdb.results.pdb\n";
	print OUT "\n";
	print OUT "bg white\n";
	print OUT "hide everything\n";
	print OUT "\n";
	#print OUT "select peptide, chain B\n";
	#print OUT "deselect\n";
	print OUT "select receptor, chain A\n";
	print OUT "deselect\n";
	print OUT "#select backbone, name c+n+o+ca and !het and !peptide\n";
	print OUT "#deselect\n";
	print OUT "#select prot, !het and !peptide\n";
	print OUT "#deselect\n";
	print OUT "\n";
	print OUT "cmd.spectrum('b', 'blue_white_red', selection='receptor')\n\n";
	#print OUT "color yellow, peptide\n";
	#print OUT "show sticks, peptide\n";
	print OUT "color yellow, het\n";
	print OUT "show sticks, het\n";
	print OUT "show spheres, receptor\n";

	close(OUT);
}

sub getResLinesStringFromClassification{
	my ($resName, $resNum) = @_;
	
	# Update temperature factore according to classification
	my $resFormat = sprintf("^.{17}%s A%4s.*", $resName, $resNum);
	
	# Get residue classification
	my $classificationValue = $outputMatLines[$exampleIndex];
	$exampleIndex++;
	#my $classificationDecision = "0.00";
	if($classificationValue >= 0){
		#$classificationDecision = "1.00";
		
		for(my $j = 0; $j < scalar @pdbLines; $j++){
			if($pdbLines[$j] =~ m/$resFormat/){
				# set b-factor to 1.00
				if($classificationValue >= 1){
					$pdbLines[$j] =~ s/^(.{60})......(.*)/$1  1.00$2/;
				}
				else{
					my $formattedVal = sprintf("%.2f", $classificationValue);
					$pdbLines[$j] =~ s/^(.{60})......(.*)/$1  $formattedVal$2/;
				}
			}
		}
	}
	
	

	#return getUpdatedLines($classificationDecision, $resFormat);
}

sub getResLinesStringNoClassification{
	my ($resNum) = @_;
	my $classificationDecision = "0.00";
	
	# Update temperature factore according to classification
	my $resFormat = sprintf("^.{20} A%4s.*", $resNum);
	return getUpdatedLines($classificationDecision, $resFormat);
}

sub getUpdatedLines{
	my ($classificationDecision, $resFormat) = @_;
	#print "decision $classificationDecision\n";
	print "resFormat $resFormat\n";
	
	my @resLinesInPDB = grep(/$resFormat/, @pdbLines);
	print "num of lines: ".(scalar @resLinesInPDB)."\n";
	for(my $j = 0; $j < scalar @resLinesInPDB; $j++){
		$resLinesInPDB[$j] =~ s/^(.{60})......(.*)/$1  $classificationDecision$2/;
	}
	my $resLinesStr = join("", @resLinesInPDB);
	return $resLinesStr;
}
