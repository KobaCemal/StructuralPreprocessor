#! /bin/sh
dataset=$1

### Change the directory to the dataset of interest
cd Datasets/"$dataset"

### Create folders for upcoming analyses
mkdir -p Volumes

### Analysis Begins
for sub in `cat "$dataset"_list.txt`
do
	# Extract volume information
	echo "Extracting volume info $sub"
	for tissue in Brain CSF GM WM
	do
		fslstats ANTS/"$sub"_ANTS/"$sub"_ANTSBrainExtraction"$tissue".nii.gz -V | cut -d " " -f 2 >> Volumes/"$dataset"_"$tissue"-volumes.txt
	done

	for struct in L_Amyg R_Amyg L_Caud R_Caud L_Hipp R_Hipp L_Pall R_Pall L_Puta R_Puta L_Thal R_Thal
	do
		fslstats First/"$sub"_First/"$sub"_First-"$struct"_corr.nii.gz -V | cut -d " " -f 2 >> Volumes/"$dataset"_"$struct"-volumes.txt
	done
	
	fslstats ANTS/"$sub"_ANTS/"$sub"_ANTS_Cereb.nii.gz -V | cut -d " " -f 2 >> Volumes/"$dataset"_Cereb-volumes.txt
	
done

### Create a blank file with headers to concatenate the txt files
echo "ID Brain CSF GM WM L_Amyg R_Amyg L_Caud R_Caud L_Hipp R_Hipp L_Pall R_Pall L_Puta R_Puta L_Thal R_Thal Cereb" > Volumes/"$dataset"_allVolumetricInfo.txt

### Merge all the volume files
paste -d " " "$dataset"_list.txt Volumes/"$dataset"_Brain-volumes.txt Volumes/"$dataset"_CSF-volumes.txt Volumes/"$dataset"_GM-volumes.txt Volumes/"$dataset"_WM-volumes.txt Volumes/"$dataset"_L_Amyg-volumes.txt Volumes/"$dataset"_R_Amyg-volumes.txt Volumes/"$dataset"_L_Caud-volumes.txt Volumes/"$dataset"_R_Caud-volumes.txt Volumes/"$dataset"_L_Hipp-volumes.txt Volumes/"$dataset"_R_Hipp-volumes.txt Volumes/"$dataset"_L_Pall-volumes.txt Volumes/"$dataset"_R_Pall-volumes.txt Volumes/"$dataset"_L_Puta-volumes.txt Volumes/"$dataset"_R_Puta-volumes.txt Volumes/"$dataset"_L_Thal-volumes.txt Volumes/"$dataset"_R_Thal-volumes.txt Volumes/"$dataset"_Cereb-volumes.txt>> Volumes/"$dataset"_allWoHeader.txt
cat Volumes/"$dataset"_allWoHeader.txt >> Volumes/"$dataset"_allVolumetricInfo.txt



