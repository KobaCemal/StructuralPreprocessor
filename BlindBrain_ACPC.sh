#! /bin/sh
dataset=$1

cd Datasets/"$dataset"

### Analysis begins
for sub in `cat "$dataset"_list.txt`
do
	### Create individual folders under slicer directory
	mkdir -p ACPC/Slicer/"$sub"_ACPC_Slicer

	#### Fix the problem of fsl 
	fslreorient2std "$sub".nii.gz ACPC/"$sub"_reor.nii.gz

	### Calculate the affine registration matrix to MNI Space
	echo "Affine registration $sub $dataset"
	flirt -in ACPC/"$sub"_reor.nii.gz -ref ../../Materials/MNI152_T1_1mm.nii.gz -omat ACPC/"$sub"_MNI.mat

	### Takes 12 dof transformation from FLIRT, and calculates best 6. So You send the image to standard space but preserving the original dimensions.
	echo "Convert affine matrix to rigid $sub" 
	aff2rigid ACPC/"$sub"_MNI.mat ACPC/"$sub"_ACPC.mat

	### Apply ACPC matrix on the raw image
	echo "$sub to ACPC plane"
	flirt -in ACPC/"$sub"_reor.nii.gz -ref ../../Materials/MNI152_T1_1mm.nii.gz -applyxfm -init ACPC/"$sub"_ACPC.mat -out ACPC/"$sub"_ACPC.nii.gz -interp trilinear -sincwindow hanning
	for planes in x y z
	do
		for slices in 20 25 30 35 40 45 50 55 60 65 70 75 80
		do
			echo "ACPC slicer $sub $planes $slices"
			slicer ACPC/"$sub"_ACPC.nii.gz  -"$planes" 0."$slices" ACPC/Slicer/"$sub"_ACPC_Slicer/"$sub"_ACPC_"$planes"_"$slices".png
		done
	done
done
