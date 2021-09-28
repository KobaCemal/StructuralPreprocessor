#! /bin/sh

export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=6

dataset=$1

### Change the directory to the dataset of interest
cd Datasets/"$dataset"

### Analysis Begins
for sub in `cat "$dataset"_list.txt`
do
	### Create individual folders under slicer directory
	mkdir -p ANTS/Slicer/"$sub"_ANTS_Slicer ANTS/"$sub"_ANTS

	# ### Brain Extraction
	echo "bet sub $sub"
	antsBrainExtraction.sh -d 3 -a ACPC/"$sub"_ACPC.nii.gz -e ../../Materials/MICCAI2012-Multi-Atlas-Challenge-Data/T_template0.nii.gz -m ../../Materials/MICCAI2012-Multi-Atlas-Challenge-Data/T_template0_BrainCerebellumProbabilityMask.nii.gz -f ../../Materials/MICCAI2012-Multi-Atlas-Challenge-Data/T_template0_BrainCerebellumRegistrationMask.nii.gz -o ANTS/"$sub"_ANTS/"$sub"_ANTS
	
	# ##Cerebellum Segmentation, threshold and binarize cerebellum
	 ../../Materials/Scripts/antsCerebellum.sh -a ACPC/"$sub"_ACPC.nii.gz -d 3 -e ../../Materials/MICCAI2012-Multi-Atlas-Challenge-Data/T_template0.nii.gz -m ../../Materials/MICCAI2012-Multi-Atlas-Challenge-Data/T_template0_BrainCerebellumProbabilityMask.nii.gz -p ../../Materials/MICCAI2012-Multi-Atlas-Challenge-Data/Priors2/priors%d.nii.gz -o ANTS/"$sub"_ANTS/"$sub"_ANTS_Cereb_
	fslmaths ANTS/"$sub"_ANTS/"$sub"_ANTS_Cereb_BrainSegmentationPosteriors6.nii.gz -thr 0.5 ANTS/"$sub"_ANTS/"$sub"_ANTS_Cereb_thrs.nii.gz
	fslmaths ANTS/"$sub"_ANTS/"$sub"_ANTS_Cereb_thrs.nii.gz -bin ANTS/"$sub"_ANTS/"$sub"_ANTS_Cereb.nii.gz




	echo "creating quality images of ANTS $sub"
	overlay 1 1 ACPC/"$sub"_ACPC.nii.gz -a ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz 1 1000 ANTS/"$sub"_ANTS/"$sub"_ACPC_ANTS_quality.nii.gz
	overlay 1 1 ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz -a ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionCSF.nii.gz 1 1000 ANTS/"$sub"_ANTS/"$sub"_ANTS_CSF_quality.nii.gz
	overlay 1 1 ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz -a ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionGM.nii.gz 1 1000 ANTS/"$sub"_ANTS/"$sub"_ANTS_GM_quality.nii.gz
	overlay 1 1 ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz -a ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionWM.nii.gz 1 1000 ANTS/"$sub"_ANTS/"$sub"_ANTS_WM_quality.nii.gz
	overlay 1 1 ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz -a  ANTS/"$sub"_ANTS/"$sub"_ANTS_Cereb.nii.gz 1 1000 ANTS/"$sub"_ANTS/"$sub"_ANTS_Cereb_quality.nii.gz
	for planes in x y z
	do
		for slices in 20 25 30 35 40 45 50 55 60 65 70 75 80
		do
			echo "ANTS slicer $sub $planes $slices"
			slicer ANTS/"$sub"_ANTS/"$sub"_ACPC_ANTS_quality.nii.gz  -"$planes" 0."$slices" ANTS/Slicer/"$sub"_ANTS_Slicer/"$sub"_ACPCtoANTS_"$planes"_"$slices".png
			slicer ANTS/"$sub"_ANTS/"$sub"_ANTS_CSF_quality.nii.gz  -"$planes" 0."$slices" ANTS/Slicer/"$sub"_ANTS_Slicer/"$sub"_CSF_"$planes"_"$slices".png
			slicer ANTS/"$sub"_ANTS/"$sub"_ANTS_GM_quality.nii.gz  -"$planes" 0."$slices" ANTS/Slicer/"$sub"_ANTS_Slicer/"$sub"_GM_"$planes"_"$slices".png
			slicer ANTS/"$sub"_ANTS/"$sub"_ANTS_WM_quality.nii.gz  -"$planes" 0."$slices" ANTS/Slicer/"$sub"_ANTS_Slicer/"$sub"_WM_"$planes"_"$slices".png
			slicer ANTS/"$sub"_ANTS/"$sub"_ANTS_Cereb_quality.nii.gz  -"$planes" 0."$slices" ANTS/Slicer/"$sub"_ANTS_Slicer/"$sub"_Cereb_"$planes"_"$slices".png
		done
	done
done
