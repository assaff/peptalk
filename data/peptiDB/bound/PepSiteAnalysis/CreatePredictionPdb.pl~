#!/usr/bin/perl
# author: dattias
# CreatePredictionPdb

use strict;

my $dataDir = "data";
my $confidenceThresholds = 0.26;

my $predResultsFile = "";
my $topPredResultsFile = "";
my @numericChains = ();
my $numericChainsStr = "";
my @parts;
my $peptideConfidence;
my @numericChainsFinal = ();

opendir(DIR, $dataDir) or die $!;
my @pdbs = grep(/^....$/, readdir(DIR));
closedir(DIR);

chdir $dataDir;
foreach my $pdb (@pdbs) {

	$predResultsFile = "$pdb.A.pdb_.pred_final";
	$topPredResultsFile = "$pdb.topConfidencePredResults.pdb";
	next if (! -e "$pdb/$predResultsFile");

	chdir $pdb;
	print "$pdb\n";
	
	open(PRED_RESULT, "<$predResultsFile") or die $!;
	# ATOM    880  CA  HIS 5   1      32.573  19.716  57.061   2.6 0.253601
	# Grep only rows with numeric chains. These are the 1-9 top predictions.
	@numericChains = grep(/^ATOM ......  ....... \d/, <PRED_RESULT>);
	close(PRED_RESULT);
	
	@numericChainsFinal = ();
	foreach my $line(@numericChains){
		$peptideConfidence = $line;
		$peptideConfidence =~ s/^.* (.*?)$/\1/;
		#print "'$line'\n";
		#print "'$peptideConfidence'\n";
		
		if($peptideConfidence <= $confidenceThresholds){
			@numericChainsFinal = (@numericChainsFinal, $line);
		}
	}
	
	open(TOP_PRED_RESULT, ">$topPredResultsFile") or die $!;
	$numericChainsStr = join('', @numericChainsFinal);
	print TOP_PRED_RESULT $numericChainsStr;
	close(TOP_PRED_RESULT);
	
	chdir "../";
}

chdir "../";
