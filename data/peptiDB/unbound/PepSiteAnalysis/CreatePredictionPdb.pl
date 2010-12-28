#!/usr/bin/perl
# author: dattias
# CreatePredictionPdb

use strict;

my $dataDir = "data";

my $predResultsFile = "";
my $topPredResultsFile = "";
my @numericChains = ();
my $numericChainsStr = "";

opendir(DIR, $dataDir) or die $!;
my @pdbs = grep(/^....$/, readdir(DIR));
closedir(DIR);

chdir $dataDir;
foreach my $pdb (@pdbs) {

	$predResultsFile = "$pdb.A.pdb_.pred_final";
	$topPredResultsFile = "$pdb.topPredResults.pdb";
	next if (! -e "$pdb/$predResultsFile");

	chdir $pdb;
	print "$pdb\n";
	
	open(PRED_RESULT, "<$predResultsFile") or die $!;
	# ATOM    880  CA  HIS 5   1      32.573  19.716  57.061   2.6 0.253601
	# Grep only rows with numeric chains. These are the 1-9 top predictions.
	@numericChains = grep(/^ATOM ......  ....... \d/, <PRED_RESULT>);
	close(PRED_RESULT);
	
	open(TOP_PRED_RESULT, ">$topPredResultsFile") or die $!;
	$numericChainsStr = join('', @numericChains);
	print TOP_PRED_RESULT $numericChainsStr;
	close(TOP_PRED_RESULT);
	
	chdir "../";
}

chdir "../";
