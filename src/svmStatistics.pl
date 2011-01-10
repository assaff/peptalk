#!/usr/bin/perl
# author: dattias
# svmStatistics.pl

use strict;

my $trueMat = $ARGV[0];
my $predMat = $ARGV[1];
my $outFile = $ARGV[2];

open(MAT, "<$predMat") or die $!;
chomp(my @predLines = grep(!/^#/, <MAT>));
close(MAT);

open(MAT, "<$trueMat") or die $!;
chomp(my @trueLines = grep(!/^#/, <MAT>));
close(MAT);

my $numRes = scalar @predLines;

# Ugly Fix: Ignore last empty line
if($predLines[$numRes-1] eq ""){
	$numRes = $numRes-1;
}

if($numRes != scalar @trueLines){
	die "Missmatching results.\nThere's a different number of results in the prediction matrix (".($numRes).") vs. true matrix (".(scalar @trueLines).").\n";
}

my $truePositive = 0;
my $trueNegative = 0;
my $falsePositive = 0;
my $falseNegative = 0;

for(my $i = 0; $i < $numRes; $i++){
	my $pred = $predLines[$i];
	my $true = $trueLines[$i];
	$true =~ s/^(.*) .*$/$1/;
	
	if($pred <= 0.7){
		# Negative
		if($true == -1){
			$trueNegative++;
		}
		else{
			$falseNegative++;
		}
	}
	else{
		# Positive
		if($true == -1){
			$falsePositive++;
		}
		else{
			$truePositive++;
		}
	}
	
#	if($pred < 0){
#		$pred = 0;
#	}
#	if($pred > 1){
#		$pred = 1;
#	}
#		
#	# Negative
#	if($true == -1){
#		$trueNegative += (1-$pred);
#	}
#	else{
#		$falseNegative += (1-$pred);
#	}
#	# Positive
#	if($true == -1){
#		$falsePositive += $pred;
#	}
#	else{
#		$truePositive += $pred;
#	}
}

my $truePositivePercentage = GetPercentage($truePositive, $numRes);
my $trueNegativePercentage = GetPercentage($trueNegative, $numRes);
my $falsePositivePercentage = GetPercentage($falsePositive, $numRes);
my $falseNegativePercentage = GetPercentage($falseNegative, $numRes);

my $precision = ($truePositivePercentage / ($truePositivePercentage + $falsePositivePercentage)) * 100;
my $recall = ($truePositivePercentage / ($truePositivePercentage + $falseNegativePercentage)) * 100;

my $f1 = 2* ($precision*$recall) / ($precision+$recall);

open(OUT, ">$outFile") or die $!;
print OUT "Results:\n";
print OUT "True ($trueMat) vs. Pred ($predMat)\n";
print OUT "\n";
printf OUT "TP: %.2f%\n", $truePositivePercentage;
printf OUT "FP: %.2f%\n", $falsePositivePercentage;
printf OUT "TN: %.2f%\n", $trueNegativePercentage;
printf OUT "FN: %.2f%\n", $falseNegativePercentage;
print OUT "\n";
printf OUT "Precision: %.2f%\n", $precision;
printf OUT "Recall: %.2f%\n", $recall;
printf OUT "F1: %.2f%\n", $f1;
print OUT "\n";
close(OUT);

###
sub GetPercentage{
	my ($absolute, $total) = @_;
	return ($absolute/$total)*100;
}
