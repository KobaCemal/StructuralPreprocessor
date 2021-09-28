#! /bin/sh

clear

prev_list="`ls -d GroupResults/*/ 2> /dev/null | cut -d "/" -f 2 `"
lines=`echo "$prev_list" | wc -l`
prev_array=(`echo $prev_list`)
prev=0
prev_count=0
dv_list_array=(`echo L_Amyg R_Amyg L_Caud  R_Caud L_Hipp R_Hipp L_Pall R_Pall L_Puta R_Puta L_Thal R_Thal`)
bvars=0
dataset=0
dataset_list="`ls -d Datasets/*/ | cut -d "/" -f 2`"
dataset_array=(`echo $dataset_list`)
reg=0

function folders {
	
	if [ -z "$prev_list" ]; then
		echo -e "\nNo group analysis applied before.\n"
	prev=1
	else
		echo -e "--------------------------------\nNames of the previous analyses: \n--------------------------------\n\n$prev_list\n"
	fi
	return
}

function prev_check {
	
	for prev_name in ${prev_array[@]}
	do
		if [[ ! "$name" == "$prev_name" ]]; then
			prev_count=$(( $prev_count + 1))  
		fi
	done
	if  [[ "$prev_count" == "$lines" ]] ; then
		prev=1
		else
			echo -e "\nType a unique name.\n"
		prev_count=0
	fi
	
	return
}

function show_bvars {
	echo -e "\n-------------------------------\nList of dependent variables:\n-------------------------------\n"
	for i in ${dv_list_array[@]}; do echo "$i"; done
	echo ""
	return
}
function bvars_check {
	for dv in ${dv_list_array[@]}
	do
		if [[ "$struc" == "$dv" ]]; then
			bvars=1
		fi
	done
	if [ $bvars -eq 0 ]; then
		echo -e "\nType it properly.\n"
	fi
	
	return

}

function collect_bvars {
		echo -e "\n---------------------------\nList of available datasets:\n---------------------------\n\n$dataset_list"
		echo " "
		#printf 'Enter the datasets of interests with a space in between: '
		#read -a datasets
		datasets=(`echo Collignon Copenhagen Holly Kitada Merabet Montreal Pisa Turin Xiaoying Yong`)
		echo " "
		gre=`( IFS=$'|'; echo "${datasets[*]}" )`
		read -p "Blind[b], sighted[s] or both[]?: " bs
		find Datasets -type f | grep bvars | grep "$struc" | grep _"$bs" | grep -E "$gre" | sort > GroupResults/$name/"$name"_bvars_temp1.txt
		while IFS= read -r line
		do
		cat GroupResults/$name/"$name"_bvars_temp1.txt | grep "$line" >> GroupResults/$name/"$name"_bvars_temp.txt
		done < GroupResults/all_bvars.txt
		
		cat GroupResults/$name/"$name"_bvars_temp.txt | grep _b > GroupResults/$name/"$name"_bvars.txt
		cat GroupResults/$name/"$name"_bvars_temp.txt | grep _s >> GroupResults/$name/"$name"_bvars.txt

		concat_bvars GroupResults/$name/"$name"_all.bvars `cat GroupResults/$name/"$name"_bvars.txt`	
		return
		## bvar lokasyonu değişecek

}

function collect_covs {

	if [[ "$bs" == "b" ]];then
	sourceFile=GroupResults/allCBcsv
	else
	sourceFile=GroupResults/allCB.csv
	fi

	echo -e "\n---------------------------\nAvailable Regressors\n---------------------------\n"
	cat Materials/Scripts/covList.txt
	echo -e "\n\n"
	printf 'Type the numbers of the covars you want to include with a space in between: '
	read -a covs 
	echo -e "\n-------------------\nFactors and levels:\n-------------------\n"
	for i in ${covs[@]}; do

		realInd=$(( $i + 19 ))
		cov_name=`awk -v a=$realInd '{print $a}' FS=',' "$sourceFile" | head -n 1`
		awk -v a=$realInd '{print $a}' FS=',' "$sourceFile" > GroupResults/$name/covariate_"$cov_name"_"$name".txt		 
		if [[ "$cov_name" == "Age" || "$cov_name" == "BlindnessOnset" || "$cov_name" == "TimeSpentAsBlind" || "$cov_name" == "YearsOfEducation" || "$cov_name" == "BrailleOnset" ]]; then
			echo -e "$cov_name min and max:"
			cat  GroupResults/$name/covariate_"$cov_name"_"$name".txt | tail -n +2 | sed -e '/NA/d' | sort -n | head -n 1
			cat  GroupResults/$name/covariate_"$cov_name"_"$name".txt | tail -n +2 | sed -e '/NA/d' | sort -n | tail -n 1
			echo " "			
		else
			echo -e "$cov_name: \n`cat GroupResults/$name/covariate_"$cov_name"_"$name".txt | tail -n +2 | sed -e '/NA/d'| sort | uniq`\n"
		fi
	done
	awk '{print $1}' FS=',' "$sourceFile" > GroupResults/$name/covariate_AAID_"$name".txt
	paste -d " " GroupResults/$name/covariate_* > GroupResults/$name/"$name"_designMatrix_raw_temp.txt
	cat GroupResults/$name/"$name"_designMatrix_raw_temp.txt | head -n 1 | cut -d " " -f1 --complement > GroupResults/$name/"$name"_covList.txt
	cat GroupResults/$name/"$name"_designMatrix_raw_temp.txt | sort -k1 -d > GroupResults/$name/"$name"_designMatrix_raw_temp_sort.txt
	cat GroupResults/$name/"$name"_designMatrix_raw_temp_sort.txt | grep _b > GroupResults/$name/"$name"_designMatrix_raw_temp_sort_b.txt
	cat GroupResults/$name/"$name"_designMatrix_raw_temp_sort.txt | grep _s > GroupResults/$name/"$name"_designMatrix_raw_temp_sort_s.txt
	cat GroupResults/$name/"$name"_designMatrix_raw_temp_sort_s.txt >> GroupResults/$name/"$name"_designMatrix_raw_temp_sort_b.txt
	cat GroupResults/$name/"$name"_designMatrix_raw_temp_sort_b.txt | cut -d " " -f1 --complement > GroupResults/$name/"$name"_designMatrix_raw.txt
	
	echo -e "Order of the titles:\n`cat GroupResults/$name/"$name"_covList.txt | head -n 1`\n"
	
	
	while [ "$reg" -eq 0 ]; do

		read -p "Enter your regex: " regex
		
		cat GroupResults/$name/"$name"_designMatrix_raw.txt | grep -E $regex > GroupResults/$name/"$name"_designMatrix_reduced.txt
		cat GroupResults/$name/"$name"_designMatrix_raw_temp_sort_b.txt | grep -E $regex | awk '{print $1}' > GroupResults/$name/"$name"_designMatrix_reduced_AAID.txt

		cat GroupResults/$name/"$name"_designMatrix_reduced.txt
		echo
		read -p "Satisfied?? 1 - 0: " reg
	done
	cat GroupResults/$name/"$name"_designMatrix_reduced.txt >> GroupResults/$name/"$name"_covList.txt
	while IFS= read -r line
		do
		cat GroupResults/$name/"$name"_bvars_temp.txt | grep "$line" >> GroupResults/$name/"$name"_bvars.txt
		done < GroupResults/all_bvars.txt
		concat_bvars GroupResults/$name/"$name"_all.bvars `cat GroupResults/$name/"$name"_bvars.txt`	
	return
}

function binarize_regressors {
	covNumber=$((`ls GroupResults/$name/covariate_* | wc -l` -1 )) 
 	for cov_num in $(seq 1 $covNumber); do
 	covName=$(cat GroupResults/$name/"$name"_covList.txt | awk -v i=$cov_num '{print $i}' | head -n 1)
 		if [[ "$covName" == "Age" || "$covName" == "BlindnessOnset" || "$covName" == "TimeSpentAsBlind" || "$covName" == "YearsOfEducation" || "$covName" == "BrailleOnset" ]]; then
 			cat GroupResults/$name/"$name"_covList.txt | awk -v i=$cov_num '{print $i}' | tail -n +2 > GroupResults/$name/"$name"_"$covName"_binarized.txt
 			read -p "Enter the contrast for $covName: " cons
 			echo -e "$cons" > GroupResults/$name/"$name"_"$covName"_contrasts_temp.txt
		 	cat GroupResults/$name/"$name"_"$covName"_contrasts_temp.txt | sed 's/,/\n/' > GroupResults/$name/"$name"_"$covName"_contrasts.txt
 		else
		 	cat GroupResults/$name/"$name"_covList.txt | awk -v i=$cov_num '{print $i}' | tail -n +2 | sort | uniq > GroupResults/$name/"$name"_"$covName"_facList.txt
		 	echo -e "\n->$covName has following levels after reduction:\n`cat GroupResults/$name/"$name"_"$covName"_facList.txt`\n"
		 	cat GroupResults/$name/"$name"_covList.txt | tail -n +2 | awk -v i=$cov_num '{print $i}' > GroupResults/$name/"$name"_"$covName"_binarized_temp.txt
		 	while IFS= read -r -u 3 level
			do
			 	read -p "Enter a binary value for $level: " binar
		 	 	cat GroupResults/$name/"$name"_"$covName"_binarized_temp.txt | sed -e "s/^${level}$/${binar}/" >  GroupResults/$name/"$name"_"$covName"_binarized.txt
		 	 	cp GroupResults/$name/"$name"_"$covName"_binarized.txt GroupResults/$name/"$name"_"$covName"_binarized_temp.txt
		 	done 3<  GroupResults/$name/"$name"_"$covName"_facList.txt
		 	read -p "Enter the contrasts $covName: " cons
		 	echo -e "$cons" > GroupResults/$name/"$name"_"$covName"_contrasts_temp.txt
		 	cat GroupResults/$name/"$name"_"$covName"_contrasts_temp.txt | sed 's/,/\n/' > GroupResults/$name/"$name"_"$covName"_contrasts.txt
		 fi	
	done
		paste -d " "  GroupResults/$name/*_binarized.txt > GroupResults/$name/"$name"_designMatrix_binarized.txt
		paste -d " "  GroupResults/$name/*_contrasts.txt > GroupResults/$name/"$name"_contrasts.txt
		awk '{print 1}' GroupResults/$name/"$name"_designMatrix_binarized.txt > GroupResults/$name/"$name"_exch.txt

		Text2Vest GroupResults/$name/"$name"_designMatrix_binarized.txt GroupResults/$name/"$name"_matrix.mat
		Text2Vest GroupResults/$name/"$name"_contrasts.txt GroupResults/$name/"$name"_contrasts.con
		Text2Vest GroupResults/$name/"$name"_exch.txt GroupResults/$name/"$name"_exch.grp
	return

}

function vertex {

	#first_utils --vertexAnalysis --usebvars -i GroupResults/$name/"$name"_all.bvars -d GroupResults/$name/"$name"_matrix.mat -o GroupResults/$name/"$name"_vertex --useReconNative --useRigidAlign --useScale
	first_utils --vertexAnalysis --usebvars -i GroupResults/$name/"$name"_all.bvars -d GroupResults/CBDefault/CBdefaultplain.mat -o GroupResults/$name/"$name"_vertex --useReconNative --useRigidAlign --useScale


}

function permutation {

	#randomise -i GroupResults/$name/"$name"_vertex.nii.gz -o GroupResults/$name/"$name"_permutation -d GroupResults/$name/"$name"_matrix.mat -t GroupResults/$name/"$name"_contrasts.con -e GroupResults/$name/"$name"_exch.grp -m GroupResults/$name/"$name"_vertex_mask.nii.gz -n "$perms" -T -D -x
	randomise -i GroupResults/$name/"$name"_vertex.nii.gz -o GroupResults/$name/"$name"_permutation -d GroupResults/CBDefault/CBdefaultplain.mat -t GroupResults/CBDefault/CBdefaultplain.con -e GroupResults/CBDefault/CBdefault.grp -m GroupResults/$name/"$name"_vertex_mask.nii.gz -n "$perms" -T -D -x

}





##Script starts here
while [ $prev -eq 0 ]; do
	folders
	read -p "Give a unique name to the analysis: " name
	if [ -n "$prev_list" ]; then
		prev_check $name $lines
	fi
done
mkdir GroupResults/"$name"

	
show_bvars
while [ "$bvars" -eq 0 ]; do
	read -p "Choose a dependent variable: " struc
	bvars_check $structure
done
collect_bvars $bs

# Spell check is missing
#collect_covs
#binarize_regressors
read -p "How many permutations do you want?: " perms
vertex
permutation $perms
