#!/bin/bash

# FILENAME: the name of the file containing all the path for metagenome files
# begin: the begining metagenome we want to extract kmer
# end: the stop sign for extracting, this metagenome is not included
# k: the value of k for kmer

# Note: mgrast_info.csv should be put in the same dir

FILENAME=$1
begin=$2
end=$3
k=$4
i=0

# create a temp dir for each k to avoid conflict
temp="temp${k}"
if [ ! -d "${temp}" ]
then
  mkdir "${temp}"
fi

while read line
do
  i=$((i+1))
  if [ "$i" -ge "$begin" ] && [ "$i" -lt "$end" ]
  then
    echo $line
    # parse the path into array
    bar=$(echo $line | tr "/" " ")
    j=0
    for x in ${bar[@]}
    do
      array[j]=$x
      j=$((j+1))
    done
    # penultimate element is project name
    projName=${array[${#array[@]}-2]}
    echo $projName
    # last element is file name
    fileName=${array[${#array[@]}-1]}
    echo $fileName
    id=`python wrapper_get_id.py mgrast_info.csv "${fileName}" "${projName}"`
    echo $id
    STEM=$(basename "${line}" .gz)
    gunzip -c $line > "${temp}/${STEM}"
    filetype="${STEM##*.}"
    output="mgrast/k${k}/${id}_k${k}.cv"
    if [ $filetype = "fna" ]
    then
      echo $filetype
      ./extract_kmer_counts -id "${id}_k${k}" -k "${k}" -f -v "${output}" "${temp}/${STEM}"
    elif [ $filetype = "fastq" ]
    then
      echo $filetype
      ./extract_kmer_counts -id "${id}_k${k}" -k "${k}" -v "${output}" "${temp}/${STEM}"
    else
      echo "Unexpected file format"
    fi
    rm "${temp}/${STEM}"
  fi
done < $FILENAME

