#!/bin/bash 

# Iterate over all of the files within our R scripts to automate
# the process of cleaning our datasets. 

# exit if any failure
set -e

SCRIPT_NAME=${0}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare -a DATASETS=(
	"irs" 
	"education" 
	"zip-codes"
)

for file in $( ls "${DIR}/../scripts/" ); do

	# Ex: irs.R --> irs
	basefile="${file%%.*}"	

	for ds in "${DATASETS[@]}"	; do
		if [[ "${ds}" == "${basefile}" ]]; then
			echo "Match found: ${ds}"
			Rscript "${DIR}/../scripts/${file}"
		fi
	done

done
