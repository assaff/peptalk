#!/bin/bash

# Training
##########

# init
cd /vol/ek/dattias/PeptideDocking/PlacementProtocol/SVM/bound/scripts
set outDir=bindingData
./createTrainingData.pl -out $outDir -outSvmlight

rm -rf ../$outDir"_results"; ./createTrainingData.pl -out $outDir

# normalization
cp trainMat trainMat.norm.svmlight; cp testMat testMat.norm.svmlight

../scripts/normalizeSampleData.pl -trainMat trainMat -testMat testMat -trainOut trainMat.norm.svmlight -testOut testMat.norm.svmlight -namesOut featureNames.svmlight -matlabTrainOut trainMat.forMatlab -matlabTestOut testMat.forMatlab

# randomization
../scripts/randomizeTrainingMatrix.pl trainMat.norm.svmlight randomTrainMat.norm.svmlight

../scripts/xFoldCrossValidation.pl trainMat.norm.svmlight CrossValidation trainSet

# learning
set posOverNeg = 12
/vol/ek/share/bin/svm_learn -l learn.trans.predict -j $posOverNeg trainMat.norm.svmlight svmModel.svmlight >! svmLearn.log

/vol/ek/share/bin/svm_learn -x 1 randomTrainMat.norm.svmlight svmModel.svmlight >! svmLearn.log

head -1 trainMat.norm.svmlight | sed 's/ /\n/g' | grep -v "#" >! featureNames.svmlight
cat ../scripts/weightsScript

# classification
/vol/ek/share/bin/svm_classify trainMat.norm.svmlight svmModel.svmlight classificationOutput.forAll.svmlight >! svmClassify.all.log
/vol/ek/share/bin/svm_classify randomTrainMat.norm.svmlight svmModel.svmlight classificationOutput.random.svmlight >! svmClassify.random.log

cat svmClassify.all.log
cat svmClassify.random.log
../scripts/showResults.pl classificationOutput.forAll.svmlight trainMat SVMResults

# classification of train and test
/vol/ek/share/bin/svm_classify trainMat.norm.svmlight svmModel.svmlight classificationOutput.train.svmlight >! svmClassify.train.log
cat svmClassify.train.log

/vol/ek/share/bin/svm_classify trainMat.classify svmModel.svmlight classificationOutput.train.svmlight >! svmClassify.train.log
cat svmClassify.train.log

/vol/ek/share/bin/svm_classify testMat.norm.svmlight svmModel.svmlight classificationOutput.test.svmlight >! svmClassify.test.log
cat svmClassify.test.log

../scripts/showResults.pl classificationOutput.train.svmlight trainMat SVMResultsTrain "unbound"
../scripts/showResults.pl classificationOutput.train.svmlight trainMat.classify SVMResultsTrain "unbound"
../scripts/showResults.pl classificationOutput.test.svmlight testMat SVMResultsTest "bound"

../scripts/showResultsForPrediction.pl classificationOutput.test.svmlight testMat SVMResultsTest /vol/ek/dattias/PeptideDocking/PlacementProtocol/forBarak/pdbs

# Cleaning
#../scripts/cleanLonelyPositives.pl classificationOutput.test.svmlight testMat SVMResultsTest classificationOutput.test.clean.svmlight > clean.log
#../scripts/showResults.pl classificationOutput.test.clean.svmlight testMat SVMResultsTest.clean "bound"
#
#../scripts/cleanLonelyPositives.pl classificationOutput.train.svmlight trainMat SVMResultsTrain classificationOutput.train.clean.svmlight > clean.log
#../scripts/showResults.pl classificationOutput.train.clean.svmlight trainMat SVMResultsTrain.clean "unbound"

# Stats
../scripts/svmStatistics.pl trainMat classificationOutput.train.svmlight stats.train.txt
../scripts/svmStatistics.pl testMat classificationOutput.test.svmlight stats.test.txt
../scripts/svmStatistics.pl testMat classificationOutput.test.clean.svmlight stats.test.clean.txt
../scripts/svmStatistics.pl testMat classificationOutput.test.clean.blur.svmlight stats.test.clean.blur.txt

cat stats.train.txt
cat stats.test.txt
cat stats.test.clean.txt
cat stats.test.clean.blur.txt


# Save Classifier
cp trainMat svmModel.svmlight  trainMat.norm.svmlight trainMat.classify ../UpdatedClassifier/

# Prediction
############
cd /vol/ek/dattias/PeptideDocking/PlacementProtocol/SVM/bound/scripts

set outDir=PredForBarak_testSet
set predDir="/vol/ek/dattias/PeptideDocking/PlacementProtocol/Predictions/"
#set predDir="/vol/ek/dattias/PeptideDocking/PlacementProtocol/forBarak/"
./createTrainingData.pl -out $outDir -full -predDir $predDir

cd ../$outDir"_results"
rm -f trainMat
cp ../UpdatedClassifier/svmModel.svmlight .

# normalize...
../scripts/normalizeSampleData.pl -trainMat trainMat -testMat testMat -trainOut trainMat.norm.svmlight -testOut testMat.norm.svmlight -namesOut featureNames.svmlight -matlabTrainOut trainMat.forMatlab -matlabTestOut testMat.forMatlab
# learn...
set posOverNeg = 12
/vol/ek/share/bin/svm_learn -j $posOverNeg trainMat.norm.svmlight svmModel.svmlight >! svmLearn.log

/vol/ek/share/bin/svm_classify testMat.norm.svmlight svmModel.svmlight classificationOutput.test.svmlight >! svmClassify.test.log
cat svmClassify.test.log

../scripts/showResultsForPrediction.pl classificationOutput.test.svmlight testMat SVMResultsTest $predDir/pdbs

# Uncommons
###########
# Old normalization script format
#../scripts/normalizeSampleData.pl trainMat trainMat.norm.svmlight featureNames.svmlight

# Duplicate positive examples
#../scripts/randomlyDuplicatePositiveExamples.pl trainMat.norm.svmlight randomTrainMat.norm.svmlight

#  Full run
#./createTrainingData.pl -full -out newData -burriedResiduesRedo -contactingResiduesRedo -holesRedo

# Binarize data
#  ../scripts/normalizeSampleData.pl "learn" trainMat.svmlight trainMat.binary.svmlight
#  ../scripts/normalizeSampleData.pl "names" trainMat.svmlight featureNames.binary.svmlight

# Remove noisy features
# ../scripts/removeNoisyFeatures.pl trainMat.binary.svmlight trainMat.binary.noNoise.svmlight featureNames.binary.svmlight  featureNames.binary.noNoise.svmlight
