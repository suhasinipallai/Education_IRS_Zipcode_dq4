#!/bin/bash

# exit if any failure
set -e

SCRIPT_NAME=${0}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage {
    echo "usage: $SCRIPT_NAME [--install-packages] [--clean-data] [--merge-data] [--all]"
    echo "  --install-packages      install all packages that would be used in this project"
    echo "  --clean-data    clean data included within the project"
    echo "  --merge-data  merge data after being cleaned"
    echo "  --all      Go through entire process of installing packages, cleaning, and merging data"
    echo "  --help             display help"
    exit 1
}

for i in "$@"
do
case $i in
	--help)
	usage
	;;	
	*)
	# unknown option
	;;
esac
done

echo "Current directory: $DIR"
