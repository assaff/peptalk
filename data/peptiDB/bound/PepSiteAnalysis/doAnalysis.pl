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
my $NO_CONFIDENT_PREDS = 0;
my $NO_HITS = 1;
my $PARTIAL_HITS = 2;
my $FULL_MATCH = 3;
my $NO_ANALYSIS = 4;

my %ClassStr = (
	$NO_CONFIDENT_PREDS => "NO_CONFIDENT_PREDS",
	$NO_HITS => "NO_HITS",
	$PARTIAL_HITS => "PARTIAL_HITS",
	$FULL_MATCH => "FULL_MATCH",
	$NO_ANALYSIS => "NO_ANALYSIS"
);

opendir(DIR, $dataDir) or die $!;
my @pdbs = grep(/^....$/, readdir(DIR));
closedir(DIR);

my $class = "";
my $classificationStr = "";
my $pdbDir = "";
my $numConfidentPred = -1;
my $numPredsNearPeptide = -1;

open(OUT, ">$classificationFile") or die $!;
foreach my $pdb (@pdbs) {
	
	print "$pdb\n";
	my $pdbDir = "$dataDir$pdb/";
	chdir $pdbDir;
	
	$numConfidentPred = -1;
	$numPredsNearPeptide = -1;
	getNumPredictionsNearPeptide($pdb, \$numConfidentPred, \$numPredsNearPeptide);
	$class = findClassification($pdb, $numConfidentPred, $numPredsNearPeptide);
	$classificationStr = $pdb.": ".$ClassStr{$class}." $numPredsNearPeptide/$numConfidentPred ($class)\n";
	print OUT $classificationStr;
	#print "classification: $classificationStr\n";
	
	chdir "../../";
}
close(OUT);

open(OUT, ">$classificationSummary") or die $!;
	print OUT printClass($NO_CONFIDENT_PREDS);
	print OUT printClass($NO_HITS);
	print OUT printClass($PARTIAL_HITS);
	print OUT printClass($FULL_MATCH);
	print OUT printClass($NO_ANALYSIS);
close(OUT);

##############################################################

sub printClass{
	my ($class) = @_;
	#chomp(my $c = `cat $classificationFile | cut -d" " -f2,3 | sort | grep -c "($class)"`);
	chomp(my $c = `grep -c "($class)" $classificationFile`);
	my $str = $ClassStr{$class}." ($class) - $c\n";
	return $str;
}

sub findClassification{
	my ($pdb, $numConfidentPred, $numPredsNearPeptide) = @_;

	if($numPredsNearPeptide == -1){
		return $NO_ANALYSIS;
	}
	if($numConfidentPred == 0){
		return $NO_CONFIDENT_PREDS;
	}
	if($numPredsNearPeptide == 0){
		return $NO_HITS;
	}
	if($numPredsNearPeptide < $numConfidentPred){
		return $PARTIAL_HITS;
	}
	return $FULL_MATCH;
}

sub getNumPredictionsNearPeptide{
	my ($pdb, $numConfidentPred, $numPredsNearPeptide) = @_;
	
	my $topPredResultsFile = "$pdb.topConfidencePredResults.pdb";
	
	#print `pwd`;
	if (!( -e "$topPredResultsFile")){
		$$numPredsNearPeptide = -1;
		$$numConfidentPred = -1;
		return;
	}
	
	chomp($$numConfidentPred = `wc -l $topPredResultsFile | cut -d" " -f1`);

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
	
	$$numPredsNearPeptide = scalar @predResFound;
	#return (scalar @predResFound);
}
