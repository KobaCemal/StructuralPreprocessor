#! /bin/sh
dataset=$1

### Change the directory to the dataset of interest
cd Datasets/"$dataset"


### Analysis Begins
for sub in `cat "$dataset"_list.txt`
do
	### Create individual folders under slicer directories
	mkdir -p First/Slicer/"$sub"_First_Slicer First/"$sub"_First 

	### Subcortical segmentation
	echo "Subcortical segmentation $sub"
	run_first_all -i ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz -d -b -s L_Amyg,L_Caud,L_Hipp,L_Pall,L_Puta,L_Thal,R_Amyg,R_Caud,R_Hipp,R_Pall,R_Puta,R_Thal -o First/"$sub"_First/"$sub"_First
	### Cerebellum segmentation
	#first_flirt ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz First/"$sub"_First/"$sub"_ff.nii.gz -b -cort
	#run_first -i ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz -t First/"$sub"_First/"$sub"_ff_cort.mat -n 40 -o First/"$sub"_First/"$sub"_R-Cereb_uncorr -m /home/programmi/fsl/data/first/models_336_bin/intref_puta/R_Cereb.bmv -intref /home/programmi/fsl/data/first/models_336_bin/05mm/R_Cereb_05mm.bmv
	#run_first -i ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz -t First/"$sub"_First/"$sub"_ff_cort.mat -n 40 -o First/"$sub"_First/"$sub"_L-Cereb_uncorr -m /home/programmi/fsl/data/first/models_336_bin/intref_puta/L_Cereb.bmv -intref /home/programmi/fsl/data/first/models_336_bin/05mm/L_Cereb_05mm.bmv
	
	#first_boundary_corr -s First/"$sub"_First/"$sub"_L-Cereb_uncorr  -i ../"$dataset"/"$sub".nii.gz -b fast -o First/"$sub"_First/"$sub"_First-L_Cereb_corr.nii.gz
	#first_boundary_corr -s First/"$sub"_First/"$sub"_R-Cereb_uncorr  -i ../"$dataset"/"$sub".nii.gz -b fast -o First/"$sub"_First/"$sub"_First-R_Cereb_corr.nii.gz
	
	echo "creating quality images of subcortical segmentation $sub"
	overlay 1 1 ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz -a First/"$sub"_First/"$sub"_First_all_none_firstseg.nii.gz 1 1000 First/"$sub"_First/"$sub"_sub_seg_quality.nii.gz
	#overlay 1 1 ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz -a First/"$sub"_First/"$sub"_First-R_Cereb_corr.nii.gz 1 1000 First/"$sub"_First/"$sub"_First-R_Cereb_quality.nii.gz
	#overlay 1 1 ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtractionBrain.nii.gz -a First/"$sub"_First/"$sub"_First-L_Cereb_corr.nii.gz 1 1000 First/"$sub"_First/"$sub"_First-L_Cereb_quality.nii.gz
	for planes in x y z
	do
		for slices in 20 25 30 35 40 45 50 55 60 65 70 75 80
		do
			echo "First slicer $sub $planes $slices"
			slicer First/"$sub"_First/"$sub"_sub_seg_quality.nii.gz  -"$planes" 0."$slices" First/Slicer/"$sub"_First_Slicer/"$sub"_First_"$planes"_"$slices".png
		done
	done
done
