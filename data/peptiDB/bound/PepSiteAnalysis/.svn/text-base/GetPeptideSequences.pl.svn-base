#!/usr/bin/perl
# author: dattias
# GetPeptideSequences

use strict;

my $oneLetter = shift;
my $convertToOneLetter = 0;
if(defined $oneLetter){
	$convertToOneLetter = 1;
}


my $dbDir = "/vol/ek/londonir/CleanPeptiDB/db/";
my $dataDir = "data/";

my %aa_XXX_to_X = ( 'ala' => 'A',
                 'arg' => 'R',
                 'asn' => 'N',
                 'asp' => 'D',
                 'cys' => 'C',
                 'gln' => 'Q',
                 'glu' => 'E',
                 'gly' => 'G',
                 'his' => 'H',
                 'ile' => 'I',
                 'leu' => 'L',
                 'lys' => 'K',
                 'met' => 'M',
                 'phe' => 'F',
                 'pro' => 'P',
                 'ser' => 'S',
                 'thr' => 'T',
                 'trp' => 'W',
                 'tyr' => 'Y',
                 'val' => 'V',
                 'asx' => 'B',
                 'glx' => 'Z',
                 'xaa' => 'X'
);


opendir(DIR, $dbDir) or die $!;
while (my $file = readdir(DIR)) {
	next if (!($file =~ m/^(....)\.pdb/));
	my $pdb = $1;
	
	mkdir $pdb;
	chdir $pdb;
	
	my $pdbFile = "$dbDir$pdb.pdb";
	`ln -s $dbDir$pdb.pdb $pdb.pdb`;
	`extract_chains_and_range.pl -p $pdb.pdb -c A -o $pdb.A.pdb`;
	
	my @pepRes;
	getPeptideResidues($pdbFile, \@pepRes, $convertToOneLetter);
	
	my $resStr = "@pepRes";
	$resStr =~ s/\s//g;
	
	open(OUT, ">$pdb.peptideResidues") or die $!;
	print OUT "$resStr\n";
	
	if(scalar @pepRes > 10){
		print "**$pdb: $resStr\n";
	}
	else{
		print "$pdb: $resStr\n";
	}
	
	close OUT;
	
	chdir "../";
}

closedir(DIR);

############################################
sub convertToOneLetterCode{
	my ($aa3code) = @_;
    return $aa_XXX_to_X{ lc($aa3code) };
}

sub getPeptideResidues{
	my($pdbFile, $pepResList, $convertToOneLetter) = @_;
	
	open(PDB, "<$pdbFile") or die $!;
	my @lines = grep(/^ATOM .* B /, <PDB>);
	my %pepResHash;

	foreach my $line(@lines){
		$line =~ m/ATOM ......  ....(...) .(....)/;
		my $res = $1;
		my $resNum = $2;
		#print "res: $res\n";
		trim(\$res);
		
		if($convertToOneLetter){
			$res = convertToOneLetterCode($res);
			#print "res: $res\n";
		}
		
		if(! defined $pepResHash{$resNum}){
			$pepResHash{$resNum} = 1;
			@$pepResList = (@$pepResList, $res);
		}
	}
	
	close(PDB);
}

sub trim{
	my($str) = @_;
	$$str =~ s/^\s+//;
	$$str =~ s/\s+$//;
}

