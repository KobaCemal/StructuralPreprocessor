#! /bin/sh

### In the dataset folder, there must be only the raw anatomical images of blind and sighted ones.
### The extension can be .nii or .nii.gz. Changing the extension of the input on the "flirt" commands (both of them) will be sufficient to adapt the code.
### File name convention must be arranged before. It must be as following: datasetName_b001 or datasetName_s001. b for blind, s for sighted. Numbers must always have 3 digits. To avoid confusion, dataset names will be kept.
clear

aname=0
list=0
final=0
dataset_list="`ls -d Datasets/*/ | cut -d "/" -f 2`"
dataset_array=(`echo $dataset_list`)
analysis_array=(`echo "ACPC ANTS First Volumes Group Report"`)

function main_menu {
echo "
Select the analysis of interest:

-> ACPC
-> ANTS
-> First
-> Volumes
-> Group
-> Report
"

return
}


function analysis_spell_check {
	for analysis_name in ${analysis_array[@]}
	do
		if [[ "$analysis" == "$analysis_name" ]]; then
			aname=1
		fi
	done
	if [ $aname -eq 0 ]; then
		echo -e "\n!!!!!!!!!!!Type it properly!!!!!!!!!!!\n"
	fi
	
	return
}


function body {

	if [ "$analysis" == "Group" ]; then
		bash Materials/Scripts/BlindBrain_Group.sh
		exit 0
	elif [ "$analysis" == "Report" ]; then
		bash Materials/Scripts/BlindBrain_Report.sh
		exit 0
	else
		echo -e "\n-------------------\nAvailable Datasets:\n-------------------\n\n$dataset_list\n"
	fi
	return
}

function dataset_spell_check {
	for dataset_name in ${dataset_array[@]}
	do
		if [[ "$dataset" == "$dataset_name" ]]; then
			list=1
		fi
	done
	if [ $list -eq 0 ]; then
		echo -e "\n!!!!!!!!!!!Type it properly!!!!!!!!!!!\n"
	fi
	
	return
}

function folders {
	found=`ls -d Datasets/$dataset/*/ 2> /dev/null | cut -d "/" -f "3"`
	if [ -z "$found" ]; then
		echo -e "\n-------------------------------------------\nNo analysis applied on $dataset dataset before.\n-------------------------------------------\n"
	else
		echo -e "\n------------------------------------------------------------\nResults of following analyses have been found in $dataset folder:\n-------------------------------------------------------------\n\n$found\n"
	fi
return
}

function confirm {
	 if [[ "$conf" =~ ^[yn]$ ]]; then
	 	final=1
	 else echo -e "\n!!!!!!!!!!!!!Wrong choice. Enter only \"y\" or \"n\".!!!!!!!!!!!!!\n"
	fi
	return
}


##### Script Starts here

while [ $aname -eq 0 ]; do
	main_menu
	read -p "Type the preferred analysis: " analysis
	analysis_spell_check $analysis
done
body $analysis


while [ $list -eq 0 ]; do
	read -p "Type the name of the dataset: " dataset
	dataset_spell_check $dataset
done

folders $dataset


while [ $final -eq 0 ]; do
	read -p "$analysis procedure will be applied on $dataset dataset. Proceed? [y/n]: " conf
	confirm $conf
done

if [[ $conf == "y" ]] ; then
	ls Datasets/"$dataset" | grep .nii | cut -d "." -f 1 > Datasets/"$dataset"/"$dataset"_list.txt
	bash BlindBrain_"$analysis".sh "$dataset"
else
	echo "See you when you are sure!"	
fi
