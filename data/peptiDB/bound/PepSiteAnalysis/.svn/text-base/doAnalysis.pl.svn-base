#!/usr/bin/perl
# author: dattias
# doAnalysis

use strict;

my $dataDir = "data/";
my $modelName = "model.pdb";
my $rasScriptName = "../../predictiondNearPeptide.rasscript";

# Files
my $classificationFile = "classificationResults.txt";
my $classificationSummary = "classificationSummary.txt";

# Classification
my $NONE = 0;
my $ONE_PRED = 1;
my $TWO_TILL_FOUR_PREDS = 2;
my $FIVE_PLUS_PREDS = 3;
my $NO_ANALYSIS = 4;

my %ClassStr = (
	$NONE => "NONE",
	$ONE_PRED => "1_PRED",
	$TWO_TILL_FOUR_PREDS => "2-4_PREDS",
	$FIVE_PLUS_PREDS => "5+_PREDS",
	$NO_ANALYSIS => "NO_ANALYSIS"
);

opendir(DIR, $dataDir) or die $!;
my @pdbs = grep(/^....$/, readdir(DIR));
closedir(DIR);

my $class = "";
my $classificationStr = "";
my $pdbDir = "";

open(OUT, ">$classificationFile") or die $!;
foreach my $pdb (@pdbs) {
	
	print "$pdb\n";
	my $pdbDir = "$dataDir$pdb/";
	chdir $pdbDir;
	
	$class = findClassification($pdb);
	$classificationStr = $pdb.": ".$ClassStr{$class}." ($class)\n";
	print OUT $classificationStr;
	#print "classification: $classificationStr\n";
	
	chdir "../../";
}
close(OUT);

open(OUT, ">$classificationSummary") or die $!;
	print OUT printClass($NONE);
	print OUT printClass($ONE_PRED);
	print OUT printClass($TWO_TILL_FOUR_PREDS);
	print OUT printClass($FIVE_PLUS_PREDS);
	print OUT printClass($NO_ANALYSIS);
close(OUT);

##############################################################

sub printClass{
	my ($class) = @_;
	chomp(my $c = `cat $classificationFile | cut -d" " -f2,3 | sort | grep -c "($class)"`);
	my $str = $ClassStr{$class}." ($class) - $c\n";
	return $str;
}

sub findClassification{
	my ($pdb) = @_;
	
	my $numPredResFound = getNumPredictionsNearPeptide($pdb);
	
	if($numPredResFound == -1){
		return $NO_ANALYSIS;
	}
	if($numPredResFound == 0){
		return $NONE;
	}
	if($numPredResFound == 1){
		return $ONE_PRED;
	}
	if($numPredResFound > 1 && $numPredResFound < 5){
		return $TWO_TILL_FOUR_PREDS;
	}
	if($numPredResFound >= 5){
		return $FIVE_PLUS_PREDS;
	}
	
	print "ERROR: num of predictions found is $numPredResFound\n";
	return $NONE;
}

sub getNumPredictionsNearPeptide{
	my ($pdb) = @_;
	
	my $topPredResultsFile = "$pdb.topPredResults.pdb";
	
	#print `pwd`;
	if (!( -e "$topPredResultsFile")){
		return -1;
	}

	# create rasmol model
	open(MODEL, ">$modelName") or die $!;
	
	print MODEL "MODEL        0\n";
	open(PDB, "<$pdb.pdb") or die $!;
	print MODEL <PDB>;
	close(PDB);
	print MODEL "ENDMDL\n";
	
	print MODEL "MODEL        1\n";
	open(PDB, "<$topPredResultsFile") or die $!;
	print MODEL <PDB>;
	close(PDB);
	print MODEL "ENDMDL\n";
	
	close MODEL;
	# DONE: create rasmol model
	
	#print "cmd: rasmol $modelName -script $rasScriptName -nodisplay\n";
	my @results = `rasmol $modelName -script $rasScriptName -nodisplay`;
	my @predResFound = grep(/Chain: .* Group: /, @results);
	
	return (scalar @predResFound);
}
