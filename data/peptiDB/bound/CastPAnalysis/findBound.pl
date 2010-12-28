#!/usr/bin/perl
# author: dattias
# findBound

# Bound version
my $boundsFastaDir = "/vol/ek/dattias/PeptideDocking/PlacementProtocol/bound/fasta";

opendir(DIR, ".") or die $!;
my @files = grep(/^.*\.tar.gz$/, readdir(DIR));
closedir(DIR);
#print `pwd`."\n";
#print "files:@files\n";

opendir(DIR, $boundsFastaDir) or die $!;
my @pdbFiles = grep(/^....\.fasta$/, readdir(DIR));
closedir(DIR);
my %pdbs = ();
foreach my $pdb(@pdbFiles){
	$pdb =~ s/.fasta//;
	$pdbs{$pdb} = 1;
}
@list = keys %pdbs;
print "pdbs: @list\n";

my $chain;
my $code_fasta;
my $pdb_fasta;
my $currPdb = "";
foreach my $code(@files){
	next if($code =~ m/....\.DONE\.tar.gz/);
	
	$code =~ s/.tar.gz//;
	$currPdb = "";
	print "----------------------\n$code\n";
	
	`tar -xzf $code.tar.gz`;
	chdir "uploads";
	chomp($chain = `getChain.pl $code.pdb 1`);
	#print "chain: $chain\n";
	chomp($code_fasta = `getFastaFromCoords.pl -pdbfile $code.pdb -chain $chain | grep -v ">"`);
	#print "code_fasta: $code_fasta\n";
	
	foreach my $pdb(keys %pdbs){
		chomp($pdb_fasta = `cat $boundsFastaDir/$pdb.fasta | grep -v ">"`);
		#print "--------------\n";
		#print length($code_fasta)." ".length($pdb_fasta)." $pdb\n";
		#print "pdb_fasta: $pdb_fasta\n";
		#if(length($code_fasta) == length($pdb_fasta)-1){
		#	print "pdb $pdb\n";
		#}
		if($code_fasta eq $pdb_fasta){
			$currPdb = $pdb;
			delete $pdbs{$pdb};
			last;
		}
	}
	#exit;
	if($currPdb eq ""){
		print "$code - PDB not found!\n";
		chdir "../";
		#`mv uploads $code`;
		`rm -rf uploads`;
	}
	else{
		print "$code $currPdb\n";
		`mv $code.pdb $currPdb.pdb`;
		`mv $code.mouth $currPdb.mouth`;
		`mv $code.mouthInfo $currPdb.mouthInfo`;
		`mv $code.poc $currPdb.poc`;
		`mv $code.pocInfo $currPdb.pocInfo`;
		
		chdir "../";
		`mv uploads $currPdb`;
		#print "moving file: 'mv $code.tar.gz $currPdb.DONE.tar.gz'\n";
		`mv $code.tar.gz $currPdb.DONE.tar.gz`;
		#exit;
	}
}

my @missingPdbsNames = keys %pdbs;
print "Missing PDBs (".(keys %pdbs)."): @missingPdbsNames\n";
