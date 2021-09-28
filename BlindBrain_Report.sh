#!/bin/bash

mainDir="/home/cemal.koba/koba/BlindBrain"

# Simple automated HTML template
dataset_list="`ls -d $mainDir/Datasets/*/ | cut -d "/" -f 7`"
dataset_array=(`echo "$dataset_list Group"`)


function datasets {
	for dataset_name in ${dataset_array[@]}
		do
			if [ "$dataset_name" == "Collignon" ]; then
				echo "<a href="$mainDir/Materials/html/"$dataset_name"_b101.html">"$dataset_name" </a>"
			elif [ "$dataset_name" == "Group" ]; then
				echo "<a href="$mainDir/Materials/html/Zscores.html">"Group" </a>"
			else
				echo "<a href="$mainDir/Materials/html/"$dataset_name"_b001.html">"$dataset_name" </a>"
			fi

		done
}

#subject_list="`cat Datasets/`"
function subjects {
	for sub_ID in $(cat $mainDir/Datasets/"$dataset"/"$dataset"_list.txt | cut -d "_" -f 2 );
		do
			echo "<a href="$mainDir/Materials/html/"$dataset"_"$sub_ID".html">"$sub_ID" </a>"
		done
}

function metrics {
	for metric in $(echo Zscores Histograms Regression Normality Cluster Lit);
		do
			
			echo "<a href="$mainDir/Materials/html/"$metric".html">"$metric" </a>"
		
		done
}

function ACPC {
	for planes in x y z
	do
		for slices in 20 25 30 35 40 45 50 55 60 65 70 75 80
		do
			echo "<img src="$mainDir/Datasets/"$dataset"/ACPC/Slicer/"$sub"_ACPC_Slicer/"$sub"_ACPC_"$planes"_"$slices".png"/>"
		done
	done
}
function ANTS {
	for planes in x y z
	do
		for slices in 20 25 30 35 40 45 50 55 60 65 70 75 80
		do
			echo "<img src="$mainDir/Datasets/"$dataset"/ANTS/Slicer/"$sub"_ANTS_Slicer/"$sub"_ACPCtoANTS_"$planes"_"$slices".png"/>"
		done
	done
		for planes in x y z
	do
		for slices in 20 25 30 35 40 45 50 55 60 65 70 75 80
		do
			echo "<img src="$mainDir/Datasets/"$dataset"/ANTS/Slicer/"$sub"_ANTS_Slicer/"$sub"_CSF_"$planes"_"$slices".png"/>"
		done
	done
		for planes in x y z
	do
		for slices in 20 25 30 35 40 45 50 55 60 65 70 75 80
		do
			echo "<img src="$mainDir/Datasets/"$dataset"/ANTS/Slicer/"$sub"_ANTS_Slicer/"$sub"_GM_"$planes"_"$slices".png"/>"
		done
	done
		for planes in x y z
	do
		for slices in 20 25 30 35 40 45 50 55 60 65 70 75 80
		do
			echo "<img src="$mainDir/Datasets/"$dataset"/ANTS/Slicer/"$sub"_ANTS_Slicer/"$sub"_WM_"$planes"_"$slices".png"/>"
		done
	done
}

function First {
	for planes in x y z
	do
		for slices in  30 35 40 45 50 55 60 65 70 
		do
			
			echo "<img src="$mainDir/Datasets/"$dataset"/First/Slicer/"$sub"_First_Slicer/"$sub"_First_"$planes"_"$slices".png"/>"
			
		done
	done
	for planes in x y z
	do
		for slices in 20 25 30 35 
		do
			
			echo "<img src="$mainDir/Datasets/"$dataset"/ANTS/Slicer/"$sub"_ANTS_Slicer/"$sub"_Cereb_"$planes"_"$slices".png"/>"
		done
	done
}


function Zscores {

	zscorePics="`ls $mainDir/Materials/Matlab/Zscores`"

	for pic in $(echo $zscorePics)
	do
		echo "<img src="$mainDir/Materials/Matlab/Zscores/"$pic""/>"
	done
}

function Histograms {

	histogramPics="`ls $mainDir/Materials/Matlab/Histograms`"

	for pic in $(echo $histogramPics)
	do
		echo "<img src="$mainDir/Materials/Matlab/Histograms/"$pic""/>"
	done
}

function Regression {

	regPics="`ls $mainDir/Materials/Matlab/Regression`"

	for pic in $(echo $regPics)
	do
		echo "<img src="$mainDir/Materials/Matlab/Regression/"$pic""/>"
	done
}

function Normality {
	#echo "<embed src="$mainDir/Materials/Matlab/Histograms/normality.txt">"
	echo "<object width="1024" height="768" color="white" type="text/plain" data="$mainDir/Materials/Matlab/Histograms/normality.txt" border="0" >
</object>"

}

function Cluster {

	cluPics="`ls $mainDir/Materials/Matlab/Cluster`"

	for pic in $(echo $cluPics)
	do
		echo "<img src="$mainDir/Materials/Matlab/Cluster/"$pic""/>"
	done
}


function Lit {

	
		echo "<img src="$mainDir/Materials/Matlab/Lit/lit2.png"/>"
	
}
echo -e "
		<!DOCTYPE html>
		<html>
		<head>
		<title>
		Results Viewer</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<style>
		body {background-color:#656565;background-repeat:no-repeat;background-position:center center;background-attachment:scroll;}
		h1{text-align:center;font-family:Arial, sans-serif;color:#ffffff;background-color:#656565;}
		p {text-align:center;font-family:Georgia, serif;font-size:14px;font-style:normal;font-weight:normal;color:#ffffff;background-color:#656565;}
		</style>
		</head>
		<body>
		<h1>Reports of Preprocessing</h1>
		<p> Choose a dataset: $(datasets) </p>
		</body>
		</html>
		" > $mainDir/GroupResults/Reports.html


for dataset in  ${dataset_array[@]}
do
	if [ "$dataset" == "Group" ]; then
		for stats in Zscores Histograms Regression Normality Cluster Lit
		do
		echo -e "
		<!DOCTYPE html>
		<html>
		<head>
		<title>
		Results Viewer</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<style>
		body {background-color:#656565;background-repeat:no-repeat;background-position:center center;background-attachment:scroll;}
		h1{text-align:center;font-family:Arial, sans-serif;color:#ffffff;background-color:#656565;}
		p {text-align:center;font-family:Georgia, serif;font-size:14px;font-style:normal;font-weight:normal;color:#ffffff;background-color:#656565;}
		</style>
		</head>
		<body>
		<h1>Quality Check</h1>
		<p> Datasets: $(datasets) </p>
		<p> Choose a metric: $(metrics) </p>
		<p> $(echo "$stats") <p>
		<body>$($stats)</body>
		</body>
		</html>
		" > $mainDir/Materials/html/"$stats".html
		done
	else

		for sub in $(cat $mainDir/Datasets/"$dataset"/"$dataset"_list.txt)
		do
			echo -e "
			<!DOCTYPE html>
			<html>
			<head>
			<title>
			Results Viewer</title>
			<meta name="viewport" content="width=device-width, initial-scale=1">
			<style>
			body {background-color:#656565;background-repeat:no-repeat;background-position:center center;background-attachment:scroll;}
			h1{text-align:center;font-family:Arial, sans-serif;color:#ffffff;background-color:#656565;}
			p {text-align:center;font-family:Georgia, serif;font-size:14px;font-style:normal;font-weight:normal;color:#ffffff;background-color:#656565;}
			</style>
			</head>
			<body>
			<h1>Results of $sub </h1>
			<p> Datasets: $(datasets) </p>
			<p> Subjects: $(subjects) </p>
			<p> ANTS: </p>
			<p> $(ANTS) </p>
			<p> Segmentations: <p>
			<p> $(First)
			<p> Datasets: $(datasets) </p>
			<p> Subjects: $(subjects) </p>
			</body>
			</html>
			" > $mainDir/Materials/html/"$sub".html
		done 
	fi
done 

firefox  $mainDir/GroupResults/Reports.html

