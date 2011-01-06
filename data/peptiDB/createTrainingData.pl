#!/usr/bin/perl
# author: dattias
# edited by: assaff
# createTrainingData.pl

use strict;
use Getopt::Long;
use FileHandle;

# Training on bound proteins

# Usage: createTrainingData.pl  [-help] [-full] [-pdb $name] [-out $outDir] [-burriedResiduesRedo] 
#								[-contactingResiduesRedo] [-holesRedo] [-motifsRedo] [-outSvmlight]
# 								[-predDir $predDirName]

##############################################################################################
# Handle command line arguments
##############################################################################################
my $help = 0;					# Print usage
my $fullRun = 0;				# Perform a fullRun (recreate all possible file info).
my $burriedResiduesRedo = 0; 	# Recreate info on burried residues.
my $contactingResiduesRedo = 0; # Recreate info on contacting residues.
my $holesRedo = 0; 				# Recreate info on holes residues.
my $motifsRedo = 0; 			# Recreate info on geometric motifs.
my $pdb = "";					# Name of a single pdb ID on which to perform training.
my $outputDir = "results"; 		# Directory for output files.
my $predictionDir = "";			# When creating test data for prediction - this directory contains the predicted PDBs data
my $outSvmlight = 0; 			# Output in svm_light format

my $pdbList="boundPdbsList.forSvm.onlyEntireData.txt";

GetOptions ("help" => \$help,
			"full" => \$fullRun, 
			"pdb=s" => \$pdb,
			"out=s" => \$outputDir,
			"burriedResiduesRedo" => \$burriedResiduesRedo,
			"contactingResiduesRedo" => \$contactingResiduesRedo,
			"holesRedo" => \$holesRedo,
			"motifsRedo" => \$motifsRedo,
			"outSvmlight" => \$outSvmlight,
			"predDir=s" => \$predictionDir,
			"pdbList=s" => \$pdbList);
			
$outputDir = "../../$outputDir"."_results";
#END##########################################################################################

if($help){
	die "Usage: createTrainingData.pl  \n".
			"\t[-help]  			Print usage\n".
			"\t[-full]  			Perform a fullRun (recreate all possible file info)\n".
			"\t[-pdb pdbId]  			Name of a single pdb ID on which to perform training\n".
			"\t[-out outDir]	  		Directory for output files\n".
			"\t[-burriedResiduesRedo]		Recreate info on burried residues\n". 
			"\t[-contactingResiduesRedo]	Recreate info on contacting residues\n".
			"\t[-holesRedo]  			Recreate info on holes residues\n".
			"\t[-motifsRedo]  			Recreate info on structural motifs\n".
			"\t[-outSvmlight]			Output in svm_light format".
			"\t[-predDir predDirName]		When creating test data for prediction - this directory contains the predicted PDBs data\n";
}

##############################################################################################
# GENERAL DEFINITIONS
##############################################################################################
my $predPdbList = "list.txt";

my $conservationDir = "ConSurfAnalysis/data/";
my $ftMapDataDir = "FTMapAnalysis/ftmapData/";
my $castPDataDir = "CastPAnalysis/CastPData/";
my $naccessSurfaceData = "SurfaceAccessability/naccessAnalysis/data/";
my $contactWithPeptideData = "ContactWithPeptide/data/";

my $mainDir = "/vol/ek/assaff/peptalk_copy/peptalk/data/peptiDB/";
my $mainBoundDir = "$mainDir/bound/";
my $mainUnboundDir = "$mainDir/unbound/";

my $boundDbDir = "$mainBoundDir/boundSet/";
my $unboundDbDir = "$mainUnboundDir/unboundSet/";

# Work modes
my $MODE_BOUND 		= "bound";
my $MODE_UNBOUND 	= "unbound";
my $MODE_PREDICT 	= "pred";

########################## OUTPUT #############################

# Create output directory
my $i = 1;
my $finalOutputDir = $outputDir;
while(-e $finalOutputDir){
	$finalOutputDir = "$outputDir.$i";
	$i++;
}
$outputDir = $finalOutputDir;

print "Output directory: $outputDir\n";
mkdir $outputDir;
my $cmd = "tar -czf $outputDir/scripts.tar /vol/ek/assaff/peptalk_copy/PlacementProtocol/SVM/bound/scripts/ >& /dev/null";
`$cmd`;


# surface residues dir
my $surfaceResiduesOutputDir = "$outputDir/SurfaceResidues";
if(! -e $surfaceResiduesOutputDir){
	mkdir $surfaceResiduesOutputDir;
}

# binding residues dir
my $bindingResiduesOutputDir = "$outputDir/BindingResidues";
if(! -e $bindingResiduesOutputDir){
	mkdir $bindingResiduesOutputDir;
}
# matlab
my $trainingMatFile = "$outputDir/trainMat";
my $trainingClassifyMatFile = "$outputDir/trainMat.classify";
my $testMatFile = "$outputDir/testMat";
# svm light
my $trainingMatFile_sl = "$outputDir/trainMat.svmlight";

my $rasmolPdbName = "rasmol.tmp.pdb";
my $rasmolLabelingPdbName = "rasmol.labeling.tmp.pdb";
my $residueLabelingRasScript = "residuesContactingPeptide.rasscript";
my $exactFragmentsRasScript = "findExactFragments.tmp.rasscript";
my $approxFragmentsRasScript = "findApproxFragments.tmp.rasscript";

# AA properties
my $PROP_NUM         = 0;
my $PROP_HYDROPHOBIC = 1;
my $PROP_POLAR       = 2;
my $PROP_AROMATIC    = 3;
my $PROP_ALIPHATIC   = 4;
my $PROP_HBONDING    = 5;
my %aaNameToProperties = ( #Num Hydrophobic Polar Aromatic Aliphatic Hbonding
   ALA =>   [1,  1, 0, 0, 1, 0],   ARG =>   [2,  0, 1, 0, 0, 1],   ASN =>   [3,  0, 1, 0, 0, 1],   ASP =>   [4,  0, 1, 0, 0, 1],   
   CYS =>   [5,  1, 1, 0, 0, 1],   GLN =>   [6,  0, 1, 0, 0, 1],   GLU =>   [7,  0, 1, 0, 0, 1],   GLY =>   [8,  1, 0, 0, 1, 0],   
   HIS =>   [9,  0, 1, 0, 0, 1],   ILE =>   [10, 1, 0, 0, 1, 0],   LEU =>   [11, 1, 0, 0, 1, 0],   LYS =>   [12, 0, 1, 0, 0, 1],  
   MET =>   [13, 1, 0, 0, 0, 0],   PHE =>   [14, 1, 0, 1, 0, 0],   PRO =>   [15, 1, 0, 0, 1, 1],   SER =>   [16, 0, 1, 0, 0, 1],  
   THR =>   [17, 0, 1, 0, 0, 1],   TRP =>   [18, 1, 0, 1, 0, 1],   TYR =>   [19, 1, 1, 1, 0, 1],   VAL =>   [20, 1, 0, 0, 1, 0],  
   OTHER => [21, 0, 0, 0, 0, 0]
);

# Motif data
my $NUMBER_OF_MOTIF_CLUSTERS = 25;
my $MINIMAL_MOTIF_NUMBER = 1;

my @pdbs = ();
if($pdb eq ""){
	my $currPdbList = ($predictionDir eq "") ? $pdbList : "$predictionDir$predPdbList";
	print "LIST FILE: $currPdbList\n";
	open(LIST, $currPdbList) or die $!;
	chomp(@pdbs = <LIST>);
	@pdbs = grep(/^....$/, @pdbs);
	print "pdbs @pdbs\n";
	close(LIST);
}
else{
	@pdbs = ($pdb);
}

#END##########################################################################################

my $trainFH = new FileHandle;
my $testFH = new FileHandle;
my $trainClassFH = new FileHandle;

$trainFH->open(">$trainingMatFile") or die $!;
$testFH->open(">$testMatFile") or die $!;
$trainClassFH->open(">$trainingClassifyMatFile") or die $!;

outputLabels("#label",
			"fragmentNormalizedRank",
			"numCloseFragments",
			"relativeConservationPerResidue",
			"residuePocketNumber",
			#"holesValuePerResidue",
			#"surfaceAccess",
			#"motifCluster",
			"AA_POLAR",
			"AA_HBONDING"
			);

foreach my $pdb(@pdbs){

	print "PDB $pdb: ".localtime(time)."\n";
	
	if($predictionDir eq ""){
		# Learn:    unbound structures
		# Test:     bound structures
		print "\tUnbound\n";
		createResultsForPdb($pdb, $mainUnboundDir, "$unboundDbDir/$pdb.pdb", $MODE_UNBOUND, $trainFH, $trainClassFH);
		
		if(-e "$boundDbDir/$pdb.pdb"){
		    print "\tBound\n";
		    createResultsForPdb($pdb, $mainBoundDir, "$boundDbDir/mainChain/$pdb.A.pdb", $MODE_BOUND, $testFH);
		}
	}
	else{
		# create test matrix for predictions
		print "\tPredict\n";
		createResultsForPdb($pdb, $predictionDir, "$predictionDir/pdbs/$pdb.pdb", $MODE_PREDICT, $testFH);
	}
}

$trainFH->close;
$testFH->close;
$trainClassFH->close;

print "chdir-ing to $outputDir\n";
chdir $outputDir;

################################################################
# $class_fh is optional and currently only present in the "bound" mode
sub createResultsForPdb{
	my ($pdb, $directory, $mainChain, $mode, $fh, $class_fh) = @_;
	
	my $currConservationDir = "$directory/$conservationDir";
	my $currFtMapDataDir = "$directory/$ftMapDataDir";
	my $currCastPDataDir = "$directory/$castPDataDir";
	my $currNaccessSurfaceData = "$directory/$naccessSurfaceData";
	my $currContactWithPeptideData = "$directory/$contactWithPeptideData";
	
	#1) Get all properties
	#2) Go over each residue number:
	#		- print residue properties to Training Matrix
	
	#print "$mainChain\n";
	open(PDB, "<$mainChain");
	my @resLines = ();
	chomp(@resLines = grep(/^ATOM .* CA /, <PDB>));
	close(PDB);

	my $resNumShift = -1;
	if($resLines[0] =~ /^ATOM..................(....)/){
		$resNumShift = $1 - 1;
	}
	else{
		print "$resLines[0]\nATOM..................(....)\n";
		print @resLines;
		die ("\tError: $mode pdb file $pdb has wrong format");
	}
	
	# Clear arrays
	my %burriedResidues = ();
	my %motifClusterPerResidue = ();
	my %resAccessability = ();
	my %contactingResidues = ();
	my %closeResidues = ();
	my %fragmentRankNormalized = ();
	my %numCloseFragmentsNormalized = ();
	my %conservationPerResidue = ();
	my %residueMoreConservedThanAvg = ();
	my %holesValuePerResidue = ();
	my %residueInPocket = ();
	my %residuePocketNumber = ();
	my %numExactFragmentsPerResidue_relative = ();
	my %numApproxFragmentsPerResidue_relative = ();
	my %numExactAtomsPerResidue_relative = ();
	my %numApproxAtomsPerResidue_relative = ();
	my %relativeConservation = ();
	my $avgConservationPerProtein = "";
	my $numFragmentsPerProtein = "";
	my $avgAtomsPerFragmentPerProtein = "";
	
	# Get data
	getBurriedResidues($pdb, $currNaccessSurfaceData, \%burriedResidues, \%resAccessability, $mainChain);
	pocketProperties($pdb, $currCastPDataDir, \%residueInPocket, \%residuePocketNumber);
	conservationProperties($pdb, $currConservationDir, \%burriedResidues, 
		\$avgConservationPerProtein, \%conservationPerResidue, \%residueMoreConservedThanAvg, \%relativeConservation);
	ftMapProperties($pdb, $mainChain, $currFtMapDataDir, \%fragmentRankNormalized, \%numCloseFragmentsNormalized);
	getLabels($pdb, $currContactWithPeptideData, \%contactingResidues, \%closeResidues, $mode, $mainChain);
	
 	my @burriedList = keys %burriedResidues;
 	#print "burriedResidues: @burriedList\n";
 	my @contactingList = keys %contactingResidues;
 	#print "contactingResidues: @contactingList\n";

	open(SURFACE, ">$surfaceResiduesOutputDir/$pdb.$mode.res") or die $!;
	
	foreach my $line(@resLines){
		#ATOM      2  CA  VAL A   2      15.037  34.451  76.538  1.00 27.91           C
		if($line =~ m/^ATOM ......  CA  (...) .(....) /){
			my $resName = $1;
			my $resNum = $2;
			trim(\$resNum);
			
			# Working ONLY on surface residues (and contacting residues)
			if(exists $burriedResidues{$resNum}){
				#next;
				if ($mode != $MODE_BOUND){
					next;
				}
				elsif(!exists $contactingResidues{$resNum}){
					next;
				}
			}
			#BEST
			#next if(exists $burriedResidues{$resNum} and !exists $contactingResidues{$resNum});
			#Not so good
			#next if(exists $burriedResidues{$resNum});
			
			# Print surface residue
			print SURFACE "$resName $resNum\n";
			
			# handle missing data #
			# Sasa
			#my $res_resAccessability = getValue($resNum, \%resAccessability, -1);
			#if($res_resAccessability == -1){
			#	die ("ERROR: no sasa data for residue ".$resNum."\n");
			#}
			# Holes
			#my $res_holesValuePerResidue = getValue($resNum, \%holesValuePerResidue, -1);
			#if($res_holesValuePerResidue == -1){
			#	die ("ERROR: no holes data for residue ".$resNum."\n");
			#}
			# Pockets
			my $res_residuePocketNumber = getValue($resNum, \%residuePocketNumber, 1);
			# Conservation
			my $res_relativeConservation = getValue($resNum, \%relativeConservation, 0);
			# FTmap
			my $res_fragmentRankNormalized = getValue($resNum, \%fragmentRankNormalized, -1);
			my $res_numCloseFragmentsNormalized = getValue($resNum, \%numCloseFragmentsNormalized, -1);
			if($res_numCloseFragmentsNormalized == -1 || $res_fragmentRankNormalized == -1){
				die ("ERROR: no ftmap data for residue ".$resNum."\n");
			}
			# Motifs
			#my $res_motifClusterPerResidue = getValue($resNum, \%motifClusterPerResidue, -1);
			#if($res_motifClusterPerResidue == -1){
			#	die ("ERROR: no motif data for residue ".$resNum."\n");
			#}

			my $bindlabel = ($mode eq $MODE_PREDICT) ? 0 : getValue($resNum, \%contactingResidues, "-1");
			my $closeLabel = getValue($resNum, \%closeResidues, "-1");
			
			my $finalLabel = $bindlabel;
			if(	$mode eq $MODE_BOUND and 
				$bindlabel eq "-1" and 
				$closeLabel eq "+1"){
				# Don't want to learn from close residues that do not bind
				# (not as negative or as positive), but they will be classified as "+1"
				# for classification purposes.
				$finalLabel = "0";
			}
			
			outputResults($fh, $pdb, $resName, $resNum, $finalLabel, 
					## FTMap
					$res_fragmentRankNormalized,
					$res_numCloseFragmentsNormalized,
					## ConSurf
					$res_relativeConservation, 
					## CastP
					$res_residuePocketNumber, 
					## RosettaHoles
					#$res_holesValuePerResidue,
					## Sasa
					#$res_resAccessability,
					## Motifs
					#$res_motifClusterPerResidue,
					## AA Properties
					getAAProperty($resName, $PROP_POLAR), 
					getAAProperty($resName, $PROP_HBONDING)
				);
				
			# output to classification file
			if($mode eq $MODE_BOUND){
				if(	$bindlabel eq "-1" and 
					$closeLabel eq "+1"){
					# Don't want to learn from close residues that do not bind
					# (not as negative or as positive), but they will be classified as "+1"
					# for classification purposes.
					$finalLabel = "+1";
				}
				
				outputResults($class_fh, $pdb, $resName, $resNum, $finalLabel, 
					## FTMap
					$res_fragmentRankNormalized,
					$res_numCloseFragmentsNormalized,
					## ConSurf
					$res_relativeConservation, 
					## CastP
					$res_residuePocketNumber, 
					## RosettaHoles
					#$res_holesValuePerResidue,
					## Sasa
					#$res_resAccessability,
					## Motifs
					#$res_motifClusterPerResidue,
					## AA Properties
					getAAProperty($resName, $PROP_POLAR), 
					getAAProperty($resName, $PROP_HBONDING)
				);
			}
		}
	}
	close (SURFACE);
}

sub outputResults{
	my ($fh, $pdb, $resName, $resNum, $label, @features) = @_;
	
	my @numberedFeatures = @features;
	numberArray(\@numberedFeatures);
	
	my $featureStr = join(" ", @features);
	my $numberedFeatureStr = join(" ", @numberedFeatures);
	
	my $infoStr = "#PDB $pdb Res $resName$resNum";
	
	if($outSvmlight){
		# svm_light format
		print $fh "$label $numberedFeatureStr $infoStr\n";
	}
	else{
		# Matlab format
		print $fh "$label $featureStr $infoStr\n";
	}
	
# 	print OUT "$label $featureStr $infoStr\n";
# 	print OUT_SL "$label $numberedFeatureStr $infoStr\n";
	#print $fh "$label $featureStr $infoStr\n";
}

sub outputLabels{
	my ($label, @features) = @_;
	
	numberArray(\@features);
	my $featureStr = join(" ", @features);
	 	
	print $trainFH "$label $featureStr\n";
	print $testFH "$label $featureStr\n";
	print $trainClassFH "$label $featureStr\n";
}

sub numberArray{
	my ($array) = @_;
	
	for(my $i = 0; $i < scalar @$array; $i++){
		$$array[$i] = ($i+1).":".$$array[$i];
	}
}

sub getValue{
	my($num, $array, $defaultVal) = @_;
	if(exists $$array{$num}){
		return $$array{$num};
	}
	else{
		return $defaultVal;
	}
}

sub trim{
	my ($str) = @_;
	$$str =~ s/\s//g;
}

sub getAAProperty{
	my ($name, $propNum) = @_;
	my $propList;
	if(exists $aaNameToProperties{$name}){
		$propList = $aaNameToProperties{$name};
	}
	else{
		$propList = $aaNameToProperties{OTHER};
	}
	return $$propList[$propNum];
}

sub getCloseResidues{
	my ($pdb, $pdbFile, $contactingResidues) = @_;
	
	# create rasmol model
	open(MODEL, ">$rasmolLabelingPdbName") or die $!;

	print MODEL "MODEL        0\n";
	open(PDB, "<$pdbFile") or die $!;
	print MODEL <PDB>;
	close(PDB);
	print MODEL "ENDMDL\n";
	print MODEL "MODEL        1\n";
	open(PDB, "<$boundDbDir/peptidesOnly/$pdb.peptide.pdb") or die $!;
	print MODEL <PDB>;
	close(PDB);
	print MODEL "ENDMDL\n";

	close MODEL;
	# DONE: create rasmol model
	
	chomp(my @rasout = `/vol/ek/share/rasmol/rasmol_32BIT $rasmolLabelingPdbName -script $residueLabelingRasScript -nodisplay`);
	#chomp(my @rasout = `/vol/ek/share/rasmol/rasmol_32BIT $boundDbDir/$pdb.pdb -script $residueLabelingRasScript -nodisplay`);
	my @results = grep(/Chain: .* Group: .*/, @rasout);
	foreach my $res(@results){
		#Chain: B  Group:  HIS   1 (C)   (10/10) atoms
		if($res =~ m/.*Chain: .  Group:  (...)(....)/){
			my $resName = $1;
			my $resNum = $2;
			trim(\$resNum);
			#print "$resName$resNum\tcontacting\n";
			$$contactingResidues{$resNum} = "+1";
		}
	}
}

# Only for bound!!!
sub getContactingResidues{
	my ($pdb, $workDir, $contactingResidues) = @_;
	
	if($fullRun || $contactingResiduesRedo){
		`rm -f $workDir$pdb.*`;
		my $cmd = "(reduce -FLIPs $boundDbDir$pdb.pdb > $workDir$pdb.H.pdb) >& /dev/null\n";
		`$cmd`;
		if(!(-e "$workDir$pdb.H.pdb")){
			die ("\tError: reduce failed on $boundDbDir$pdb.pdb");
		}
		
#		$cmd = "(/vol/ek/share/bin/probe -NOHET -NOWATer -MC -U \"ALL\" $workDir$pdb.H.pdb > $workDir$pdb.kin) >& /dev/null\n";
        $cmd = "(/vol/ek/assaff/bin/probe -NOHET -NOWATer -MC -U \"ALL\" $workDir$pdb.H.pdb > $workDir$pdb.kin) >& /dev/null\n";
		#print `$cmd`;
		`$cmd`;
		if(!(-e "$workDir$pdb.kin")){
			die ("\tError: probe failed on $workDir$pdb.H.pdb");
		}
	}
	else{
		if(! (-e "$workDir$pdb.kin")){
			die("\tError: no probe file $workDir$pdb.H.pdb");
			#return;
		}
	}

	open(CONTS, "<$workDir$pdb.kin") or die $!;
	my @lines = grep(/ A .* : B .* /, <CONTS>);
	close(CONTS);
	
	my %foundRes;
	
	open(OUT, ">$bindingResiduesOutputDir/$pdb.res") or die $!;
	foreach my $line(@lines){
		my @parts = split(/:/, $line);
		if($parts[11] >= 0.06){
			# $parts[3] holds the protein residue details
			if($parts[3] =~ m/^ .(....) (...) /){
				my $protResNum = $1;
				my $protResName = $2;
				trim(\$protResNum);
				$$contactingResidues{$protResNum} = "+1";
				if(! exists $foundRes{$protResNum}){
					print OUT "$protResName $protResNum\n";
				}
				$foundRes{$protResNum} = 1;
			}
		}
	}
	close(OUT);
}

sub getLabels{
	my ($pdb, $workDir, $contactingResidues, $closeResidues, $mode, $pdbFile) = @_;
	
	if($mode eq $MODE_PREDICT){
		return;
	}
	
	if($mode eq $MODE_BOUND){
		getContactingResidues($pdb, $workDir, $contactingResidues);
		getCloseResidues($pdb, $pdbFile, $closeResidues);
	}
	else{
		getCloseResidues($pdb, $pdbFile, $contactingResidues);
	}
}

sub motifProperties{
	my ($pdb, $workDir, $dataPerResidue, $mode, $pdbFile) = @_;

	# !! Add option to refresh the cluster data from an input directory !! 
	
	if($fullRun || $motifsRedo){
		# Remove old data
		`rm -f $workDir/$pdb/*`;
		
		# Recreate motifs data
		chomp(my $currentDir = `pwd`);
		chdir $workDir;
		
		#1. protGraph
		mkdir $pdb;
		chdir $pdb;
		my $localPdbName = "$pdb.pdb";
		my $cmd = "ln -s $pdbFile $localPdbName";
		`$cmd`;
		$cmd = "/vol/ek/dattias/PeptideDocking/bin/protGraph/protGraph.pl ".
			   "-chains all -output $pdb -verbose -alwaysReduce $localPdbName > $pdb.log";
		system $cmd;
		#2. Create matlab script
		my $scriptIn = "/vol/ek/dattias/PeptideDocking/bin/matlabScripts/pdb_findCluster.script.m";
		my $scriptOut = "$pdb.findCluster.m";
		createCustomizedScript($scriptIn, $scriptOut, $pdb);
		#3. Make sure we have the cluster data
		chdir $workDir;
		if(! -e "clustersData.mat"){
			`cp /a/miro/home/ek/dattias/PeptideDocking/Data/peptiDB.mainChains/Graphs/clustersData.mat .`;
		}
		#4. findCluster: run matlab script
		chdir $pdb;
		print "\tFinding motif cluster...\n";
		my $log = "$pdb.findCluster.log";
		$cmd = "(matlab76 -nodesktop -nodisplay -logfile $log < $scriptOut) > /dev/null";
		`$cmd`;
		# Back to main dir
		chdir $currentDir;
	}
	
	my $resultsFile = "$workDir/$pdb/$pdb.minClusters_minDist.txt";
	if(!(-e "$resultsFile")){
		return;
	}
	
	open(RES, $resultsFile) or die "Can't open $resultsFile";
	my @resLines = <RES>;
	close(RES);
	
	foreach my $line(@resLines){
		if($line =~ m/^(\d+) (\d+) .*$/){
			my $resNum = $1;
			my $clusterNum = $2;
			my $normalizedClusterNum = ($clusterNum-$MINIMAL_MOTIF_NUMBER) / ($NUMBER_OF_MOTIF_CLUSTERS-$MINIMAL_MOTIF_NUMBER);
			$$dataPerResidue{$resNum} = $normalizedClusterNum;
		}
	}
}

sub createCustomizedScript{
	my($scriptIn, $scriptOut, $pdbId) = @_;
	
	open(SCRIPT, $scriptIn) or die "Can't open $scriptIn";
	my @pdbScriptLines = <SCRIPT>;
	close(SCRIPT);
	
	my $outStr;
	foreach my $pdbScriptLine(@pdbScriptLines){
		$pdbScriptLine =~ s/PDBID_/$pdbId/g;
		$outStr .= $pdbScriptLine;
	}
	
	open(SCRIPT, ">$scriptOut") or die "Can't open $scriptOut";
	print SCRIPT $outStr;
	close(SCRIPT);
}

# $holesValuePerResidue - Avg holes value
sub rosettaHolesProperties{
	my($pdb, $workDir, $holesValuePerResidue, $resNumShift, $pdbFile) = @_;
	
	my $localPdbName = "$pdb.mainChain.pdb";
	if($fullRun || $holesRedo){
		`rm -f $workDir$pdb.*`;
		# Create RosettaHoles data
		chomp(my $currentDir = `pwd`);
		chdir $workDir;
		my $cmd = "ln -s $pdbFile $localPdbName";
		`$cmd`;
		#$cmd = "/cs/alum/londonir/lab/rosetta/mini/bin/holes.linuxgccrelease -database /vol/ek/londonir/rosetta/minirosetta_database/ ".
		#		"-holes:dalphaball /vol/ek/share/bin/DAlphaBall -holes:make_pdb -holes:make_voids -s $localPdbName > $pdb.log";
		#$cmd = "/vol/ek/londonir/rosetta/mini/build/src/release/linux/2.6/32/x86/gcc/holes.linuxgccrelease -database /vol/ek/londonir/rosetta/minirosetta_database/ ".
		#		"-holes:dalphaball /vol/ek/share/bin/DAlphaBall -holes:make_pdb -holes:make_voids -s $localPdbName > $pdb.log";
		$cmd = "/vol/ek/share/rosetta/mini/build/src/release/linux/2.6/32/x86/gcc/holes.linuxgccrelease -database /vol/ek/share/rosetta/minirosetta_database/ ".
				"-holes:dalphaball /vol/ek/share/bin/DAlphaBall -holes:make_pdb -holes:make_voids -s $localPdbName > $pdb.log";
		`$cmd`;
		chdir $currentDir;
	}
	
	if(!(-e "$workDir/$localPdbName"."_cavs.pdb")){
		return;
	}
	
	open(HOLES, "$workDir/$localPdbName"."_cavs.pdb") or die $!;
	my @holesLines = <HOLES>;
	close(HOLES);
	
	my $inRes = 0;
	my $resSum = 0;
	my $currRes = 0;
	my $numAtoms = 0;
	foreach my $line(@holesLines){
		#ATOM      1  N   VAL A   1      13.699  35.104  76.557  1.00 -0.22
		if($line =~ m/^ATOM..................(....)   .*(......)$/){
			my $resNum = $1;
			my $value = $2;
			trim(\$resNum);
			trim(\$value);
			$resNum += $resNumShift;
			
			if($inRes == 1 and $resNum != $currRes){
				$inRes = 0;
				#make avg
				$$holesValuePerResidue{$currRes} = $resSum/$numAtoms;
				# Normalization: assume range [-2 - 5]
				$$holesValuePerResidue{$currRes} = ($$holesValuePerResidue{$currRes} + 2)/7; 
			}
			if($inRes == 0){
				$resSum = 0;
				$numAtoms = 0;
				$currRes = $resNum;
				$inRes = 1;
			}
			$resSum += $value;
			$numAtoms ++;
		}
		elsif($inRes == 1){
			$inRes = 0;
			#make avg
			$$holesValuePerResidue{$currRes} = $resSum/$numAtoms;
			# Normalization: assume range [-2 - 5]
			$$holesValuePerResidue{$currRes} = ($$holesValuePerResidue{$currRes} + 2)/7;
		}
	}
}

# pocket rank does not include cavities
# default for $residuePocketNumber is 1 (no pocket)
sub pocketProperties{
	my ($pdb, $workDir, $residueInPocket, $residuePocketNumber) = @_;
	
	my $castPDir = "$workDir/$pdb";
	if(!(-e $castPDir)){
	    die "can't find castp data dir $castPDir.";
		return;
	}
	
	my %pocketRank;
	#POC: ./uploa  86   0  1373.521  3000.55   743.303  3560.20  1385.80  694
	`cat $castPDir/$pdb.pocInfo | grep -v Molecule | egrep -v "^POC: ./uploa....   0" | sort -nr -k 5 > $castPDir/$pdb.pocInfo.sorted`;
	open(POC_INFO, "$castPDir/$pdb.pocInfo.sorted") or die $!;
	my @pocketLines = <POC_INFO>;
	close(POC_INFO);
	
	## Define ranks 1 - 5 
	## Rank 6 = lower rank pocket
	## Rank 7 = no pocket
	my $rank = 1;
	foreach my $line(@pocketLines){
		if($rank > 5){
			last;
		}
		#POC: ./uploa  10   1 
		if($line =~ m/^POC: .\/uploa (...)/){
			my $pocketNumber = $1;
			trim(\$pocketNumber);
			
			$pocketRank{$pocketNumber} = $rank;
			#print "pocket ranks: pocket $pocketNumber, rank $rank\n";
			$rank++;
		}
	}

	open(POC_INFO, "$castPDir/$pdb.poc") or die $!;
	chomp(@pocketLines = <POC_INFO>);
	close(POC_INFO);
	
	my $pocketRank = 0;
	foreach my $line(@pocketLines){
		#              ATOM      6  CG1 VAL A   2      14.482  32.751  78.306  1.00 30.46  13  POC
		if($line =~ m/^ATOM..................(....) .* (...)  POC/){
			my $residueNumber = $1;
			my $pocketNumber  = $2;
			trim(\$residueNumber);
			trim(\$pocketNumber);
			
			if(exists $pocketRank{$pocketNumber}){
				$$residueInPocket{$residueNumber} = 1;
				if(exists $pocketRank{$pocketNumber}){
					$pocketRank = $pocketRank{$pocketNumber};
				}
				else{
					$pocketRank = 6;
				}
				# Normalize pocket rank (X-1 / 6). Range is [1-7]
				$pocketRank = ($pocketRank-1)/6;
				$$residuePocketNumber{$residueNumber} = $pocketRank;
				
				#print "pocket: res $residueNumber, pocket $pocketNumber, pocketRank ".$pocketRank{$pocketNumber}."\n";
			}
		}
	}
}

# $avgConservationPerProtein - over surface residues
sub conservationProperties{
	my ($pdb, $workDir, $burriedResidues,
		$avgConservationPerProtein, $conservationPerResidue, $residueMoreConsurvedThanAvg, $relativeConservation) = @_;
	
	my $conservationFile = "$workDir/$pdb/pdbFILE_view_ConSurf.pdb";
	if(!(-e $conservationFile)){
	    print "Cannot find conservation file $workDir/$pdb/pdbFILE_view_ConSurf.pdb \n running without one (assigning 0 conservation across the protein).\n";
		$$avgConservationPerProtein = 0;
		return;
	}
	
	open(FILE, "<$conservationFile") or die $!;
	chomp (my @lines = grep(/ CA /, <FILE>));
	close (FILE);
	
	my $sum = 0;
	my $numExposed = 0;
	foreach my $line(@lines){
		my $resNum = $line;
		#ATOM      2  CA  VAL A   1      16.373  33.731  77.460  1.00     8
		$resNum =~ s/^.{22}(....).*/$1/;
		trim(\$resNum);
		
		my $conservationNum = $line;
		$conservationNum =~ s/^.{65}(.).*/$1/;
		if(!exists $$burriedResidues{$resNum}){
			if($conservationNum != 0){
				$sum += $conservationNum;
				$numExposed++;
			}
		}
		
		$$conservationPerResidue{$resNum} = $conservationNum;
		#print "conservation: $resNum -> $conservationNum\n";
	}
	
	#$$avgConservationPerProtein = $sum / scalar(@lines);
	$$avgConservationPerProtein = $sum / $numExposed;
	#print "conservation: AVG -> $$avgConservationPerProtein\n";
	
	my $val;
	foreach my $resNum(keys %$conservationPerResidue){
		$val = 0;
		
		if($$conservationPerResidue{$resNum} > $$avgConservationPerProtein){
			$val = 1;
		}
		
		$$residueMoreConsurvedThanAvg{$resNum} = $val;
# 		print "RES '$resNum': AVG '$$avgConservationPerProtein', CONS '$conservationPerResidue{$resNum}', FINAL '$val'\n";
	}
	
	foreach my $resNum(keys %$conservationPerResidue){
		# Normalize this rank: possible range [0-9]
		# Normalizing according to 9/5 = 1.8 (average case)
		$$relativeConservation{$resNum} = ($$conservationPerResidue{$resNum} / $$avgConservationPerProtein) / 2;
		if($$relativeConservation{$resNum} > 1){
			$$relativeConservation{$resNum} = 1;
		}
	}
}

# This data MUST exist
sub ftMapProperties{
	my ($pdb, $pdbFile, $workDir, $fragmentRankNormalized, $numCloseFragmentsNormalized) = @_;
		
	if(! (-e "$workDir/$pdb.map.pdb")){
		# No FTMap data available
		die "\tERROR: No FTMap data available for $pdb in dir $workDir\n";
	}
	if(! (-e "$workDir/$pdb.map.clean.pdb")){
		createCleanFTMapFile($pdb, $workDir);
	}
	
	# Get fragment ranks
	my %fragmentRanks = ();
	
	findFragmentStatisticsPerProtein($pdb, $workDir, \%fragmentRanks);
	findFragmentStatisticsPerResidue($pdb, $pdbFile, $workDir, \%fragmentRanks,
		$fragmentRankNormalized, $numCloseFragmentsNormalized);	
}

sub findFragmentStatisticsPerProtein{
	my($pdb, $workDir, $fragmentRanks) = @_;
	
	my $ftmapData = "$workDir/$pdb.map.pdb";
	open(FILE, "<$ftmapData");
	chomp( my @lines = <FILE> );
	close (FILE);
	
	my %fragsInCluster;
	my $fragSize = 0;
	my $normFragSize = 0;
	my $fragRank = 0;
	my $normFragRank = 0;
	my $fragLetter;
	my @allFragsInCluster;
	my $totalFragRank = 0;
	for(my $i = 0; $i < scalar @lines; ++$i){
		if($lines[$i] =~ m/HEADER crosscluster.(...)/){
			$fragRank = ($1)+1;
			if($fragRank <= 4){
				$normFragRank = $fragRank;
			}
			else{
				$normFragRank = 5;
			}
				
			%fragsInCluster = ();
			
			++$i;
			if($lines[$i] =~ m/ATOM ...... ........ (.)/){
				$fragLetter = $1;
				
				@allFragsInCluster = grep(/ATOM ...... ........ $fragLetter/, @lines);
				$i += (scalar @allFragsInCluster -1);
				
				foreach my $frag(@allFragsInCluster){
					$frag =~ s/ATOM ...... ........ .(....)/$1/;
					trim(\$frag);
					$fragsInCluster{$frag} = 1;
				}
				
				$fragSize = scalar (keys %fragsInCluster);
				if($fragSize <= 5){
					$normFragSize = 1;
				}
				elsif($fragSize <= 10){
					$normFragSize = 2;
				}
				elsif($fragSize <= 15){
					$normFragSize = 3;
				}
				else{
					$normFragSize = 4;
				}
				
				$totalFragRank = $normFragRank/$normFragSize;
				# Normalization step
				# Values range between [1/4, 6]
				$totalFragRank = ($totalFragRank - (1/4)) / (6 - (1/4));
				
				$$fragmentRanks{$fragLetter} = $totalFragRank;
			}
		}
	}
	
#	my($pdb, $workDir, $numFragmentsPerProtein, $avgAtomsPerFragmentPerProtein) = @_;
#	
#	my $ftmapData = "$workDir/$pdb.map.pdb";
#	open(FILE, "<$ftmapData");
#	chomp( my @lines = <FILE> );
#	close (FILE);
#	
#	my @clusters = grep(/HEADER crosscluster/, @lines);
#	$$numFragmentsPerProtein = scalar @clusters;
#	if($$numFragmentsPerProtein == 0){
#		$$avgAtomsPerFragmentPerProtein = 0;
#		return;
#	}
#	
#	my @atoms = grep(/^ATOM/, @lines);
#	my $numAtomsInAllFragments = scalar @atoms;
#	$$avgAtomsPerFragmentPerProtein = $numAtomsInAllFragments/$$numFragmentsPerProtein;
#	#print "FTMap: num fragments $$numFragmentsPerProtein, avg atoms $$avgAtomsPerFragmentPerProtein, all atoms $numAtomsInAllFragments\n";
}

sub createCleanFTMapFile{
        my ($pdb, $workDir) = @_;

        open(FILE, "<$workDir/$pdb.map.pdb") or die $!;
        open(FILE_OUT, ">$workDir/$pdb.map.clean.pdb") or die $!;

        my $inProtein = 1;
        foreach my $line(<FILE>){
                if($inProtein == 1 and $line =~ m/^HEADER crosscluster/){
                        $inProtein = 0;
                }
                if($inProtein == 0){
                        print FILE_OUT $line;
                }
        }

        close(FILE_OUT);
        close(FILE);
}

sub findFragmentStatisticsPerResidue{
	my ($pdb, $pdbFile, $workDir, $fragmentRanks,
		$fragmentRankNormalized, $numCloseFragmentsNormalized) = @_;
				
	# create rasmol model
	open(MODEL, ">$rasmolPdbName") or die $!;

	print MODEL "MODEL        0\n";
	open(PDB, "<$pdbFile") or die $!;
	my @pdbLines = <PDB>;
	print MODEL @pdbLines;
	close(PDB);
	print MODEL "ENDMDL\n";

	print MODEL "MODEL        1\n";
	open(PDB, "<$workDir/$pdb.map.clean.pdb") or die $!;
	print MODEL <PDB>;
	close(PDB);
	print MODEL "ENDMDL\n";

	close MODEL;
	# DONE: create rasmol model
	
	my @pdbResLines = grep(/^ATOM .* CA /, @pdbLines);
	foreach my $resLine(@pdbResLines){
		#ATOM     32  C   VAL A   5
		#ATOM   4130  CA  PHE C 491      23.154  -2.178   6.971  1.00 45.33           C
		if($resLine =~ m/^ATOM........ CA  (...) .(....)/){
			my $resName = $1;
			my $resNum = $2;
			trim(\$resNum);
			
			# Run script for finding approximatly close fragments
			my $distance = 4.0;
			open(SCRIPT, ">$approxFragmentsRasScript") or die $!;
			my $selectCmd = sprintf("select within (%.2f, (%s%d and */0)) and not */0\n", $distance, $resName, $resNum);
			print SCRIPT $selectCmd;
			print SCRIPT "show selected\nquit\n";
			close(SCRIPT);
			
			my $numFrags = 0;
			my %fragmentChains;
			#print "/vol/ek/share/rasmol/rasmol_32BIT $rasmolPdbName -script $approxFragmentsRasScript -nodisplay\n";
			chomp(my @rasout = `/vol/ek/share/rasmol/rasmol_32BIT $rasmolPdbName -script $approxFragmentsRasScript -nodisplay`);
			my @results = grep(/Chain: .* Group: .*/, @rasout);
			foreach my $res(@results){
				if($res =~ m/Chain: (.)  Group:/){
					my $chain = $1;
					
					if(!exists $fragmentChains{$chain}){
						$fragmentChains{$chain} = 1;
						$numFrags++;
					}
				}
			}
			
			my $minScore = 1;
			foreach my $chain(keys %fragmentChains){
				if(exists $$fragmentRanks{$chain} && 
					$$fragmentRanks{$chain} < $minScore){
					$minScore = $$fragmentRanks{$chain};
				}
			}
			
			$$fragmentRankNormalized{$resNum} = $minScore;
			if($numFrags > 5){
				$numFrags = 5;
			}
			$$numCloseFragmentsNormalized{$resNum} = $numFrags / 5;
		}
	}
}

sub findNumFragmentsPerResidue{
	my ($resName, $resNum, $numFragmentsPerResidue, $numAtomsPerResidue, $numFragmentsPerResidue_relative, $numAtomsPerResidue_relative, 
	$distance, $scriptName, $numFragmentsPerProtein, $avgAtomsPerFragmentPerProtein) = @_;

	open(SCRIPT, ">$scriptName") or die $!;
	my $selectCmd = sprintf("select within (%.2f, (%s%d and */0)) and not */0\n", $distance, $resName, $resNum);
	print SCRIPT $selectCmd;
	print SCRIPT "show selected\nquit\n";
	close(SCRIPT);
	
	my $numFrags = 0;
	my $numFragAtoms = 0;
	my %chains;
	chomp(my @rasout = `/vol/ek/share/rasmol/rasmol_32BIT $rasmolPdbName -script $scriptName -nodisplay`);
	my @results = grep(/Chain: .* Group: .*/, @rasout);
	foreach my $res(@results){
		if($res =~ m/.*Chain: (.)  Group:.*\((.*)\/.*/){
			my $chain = $1;
			my $hits = $2;
			
			if(!exists $chains{$chain}){
				$chains{$chain} = 1;
				$numFrags++;
			}
			$numFragAtoms += $hits;
		}
	}
	$$numFragmentsPerResidue{$resNum} = $numFrags;
	$$numAtomsPerResidue{$resNum} = $numFragAtoms;
# 	print "FTMap: distance -> $distance, resNum -> $resNum, fragments $numFrags, atoms $numFragAtoms\n";
	if($$numFragmentsPerProtein != 0 && $$numFragmentsPerResidue{$resNum} != 0){
		$$numFragmentsPerResidue_relative{$resNum} = $$numFragmentsPerResidue{$resNum} / $$numFragmentsPerProtein;
	}
	else{
		$$numFragmentsPerResidue_relative{$resNum} = 0;
	}
# 	print "FTMAP: frags_per_protein ".$$numFragmentsPerProtein." frags_per_res ".$$numFragmentsPerResidue{$resNum}." relative ".$$numFragmentsPerResidue_relative{$resNum}."\n";
	
	if($$avgAtomsPerFragmentPerProtein != 0 && $$numAtomsPerResidue{$resNum} != 0){
		$$numAtomsPerResidue_relative{$resNum} = ($$numAtomsPerResidue{$resNum} / 
		($$avgAtomsPerFragmentPerProtein*$$numFragmentsPerResidue{$resNum}) );
	}
	else{
		$$numAtomsPerResidue_relative{$resNum} = 0;
	}
# 	print "FTMAP: atoms_per_protein ".$$avgAtomsPerFragmentPerProtein." atoms_per_res ".$$numAtomsPerResidue{$resNum}." relative ".$$numAtomsPerResidue_relative{$resNum}."\n";
}

sub getBurriedResidues{
	my ($pdb, $workDir, $burriedResidues, $resAccessability, $pdbFile) = @_;
	
	my $REL_ACCESS_THRESHOLD = 30.0; # 1.0
	
	if($fullRun || $burriedResiduesRedo){
		# Create naccess data
		chomp(my $currentDir = `pwd`);
		chdir $workDir;
		# removing old data
		`rm -f $pdb.*`;
		my $cmd = "ln -s $pdbFile $pdb.mainChain.pdb";
		`$cmd`;
		$cmd = "/vol/ek/share/bin/naccess $pdb.mainChain.pdb";
        print `$cmd`;
		chdir $currentDir;
	}
	print "done.\n";
	
	if(! (-e "$workDir$pdb.rsa")){
		die("\tERROR: missing surface access file: $workDir$pdb.rsa\n");
	}
	
	open(SURF, "<$workDir$pdb.rsa") or die $!;
	#my @lines = grep(/^RES [A-Z]{3} A[0-9 ]{4}      .00/, <SURF>);
	my @allLines = <SURF>;
	close(SURF);
	
	#REM RES _ NUM      All-atoms   Total-Side   Main-Chain    Non-polar    All polar
	#REM                ABS   REL    ABS   REL    ABS   REL    ABS   REL    ABS   REL
	#RES VAL A   1   149.58  98.8  90.46  79.2  59.12 159.1  93.51  81.0  56.07 155.9
	my @lines = ();
	foreach my $line(@allLines){
		# Not looking for any specific chain. Always performing sasa on main chain.
		if($line =~ m/^RES [A-Z]{3} .([0-9 ]{4}) [0-9\. ]{8} (.....)/){
			my $resNum = $1;
			my $relativeAccessabilityOverAllAtoms = $2;
			
			trim(\$resNum);
			if($relativeAccessabilityOverAllAtoms < $REL_ACCESS_THRESHOLD){
				@lines = (@lines, $line);
				$$burriedResidues{$resNum} = 1;
			}

			# Save res SASA data for ALL residues (burried and exposed)
				# Relative accessability in the range [0,1]
				$$resAccessability{$resNum} = $relativeAccessabilityOverAllAtoms/100;
				if($$resAccessability{$resNum} > 1){
					$$resAccessability{$resNum} = 1;
				}

		}
	}
	
	if(scalar @lines == 0){
		print ("\tWARNING: found no burried residues\n");
	}	
}
