#!/usr/bin/perl
# author: dattias
# SummaryTable

use strict;

my $analysisPMLsDir = "AnalysisPMLs";
my $dbDir = "/vol/ek/londonir/CleanPeptiDB/db/";
my $summaryTableFile = "SummaryTable.txt";

my $castPFile = "/vol/ek/dattias/PeptideDocking/PlacementProtocol/bound/CastPAnalysis/classificationResults.txt";
my $ftMapFile = "/vol/ek/dattias/PeptideDocking/PlacementProtocol/bound/FTMapAnalysis/classificationResults.txt";
my $pepSiteFile = "/vol/ek/dattias/PeptideDocking/PlacementProtocol/bound/PepSiteAnalysis/classificationResults.txt";
my $peptideSequenceFile = "/vol/ek/dattias/PeptideDocking/PlacementProtocol/peptideSequences.txt";

opendir(DIR, $dbDir) or die $!;
my @pdbs = grep(/^....\.pdb$/, readdir(DIR));
closedir(DIR);

open(SUM, ">$summaryTableFile") or die $!;

# CastP
open(RES, "<$castPFile") or die $!;
my @castPResults = <RES>;
close(RES);

# FTMap
open(RES, "<$ftMapFile") or die $!;
my @ftMapResults = <RES>;
close(RES);

# PepSite
open(RES, "<$pepSiteFile") or die $!;
my @pepSiteResults = <RES>;
close(RES);

# Peptide Sequence
open(RES, "<$peptideSequenceFile") or die $!;
my @peptideSequences = <RES>;
close(RES);

my $formatStr = "%-5s %-17s %-20s %-34s %s\n";
#print SUM "PDB Peptide_Sequence CastP_analysis FTMap_analysis PepSite_analysis\n";

print SUM sprintf($formatStr, "PDB", "Peptide_Sequence", "CastP_analysis", "FTMap_analysis", "PepSite_analysis");

foreach my $pdb (@pdbs) {

    $pdb =~ s/^(....)\.pdb/\1/;
    print "$pdb\n";
    
    my $peptideSeq = GetResultPerPdb($pdb, @peptideSequences);
    my $castPResult = GetResultPerPdb($pdb, @castPResults);
    my $ftMapResult = GetResultPerPdb($pdb, @ftMapResults);
    my $pepSiteResult = GetResultPerPdb($pdb, @pepSiteResults);
    
    print SUM sprintf($formatStr, $pdb, $peptideSeq, $castPResult, $ftMapResult, $pepSiteResult);
}

close(SUM);

###############################################
sub GetResultPerPdb{
	my ($pdb, @resList) = @_;
	
	my $str = "";

	chomp( my @res = grep(/^$pdb: /, @resList) );
	#print "@res\n";
	
    if(scalar @res == 0 || scalar @res > 1){
    	$str = "NO_ANALYSIS";
    }
    else{
    	my @parts = split(' ', $res[0]);
    	$str = $parts[1];
    }
    
    return $str;
}
