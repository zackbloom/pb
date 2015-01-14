#!/bin/bash

if [ -d "$1" ]; then
	ls $1
	exit 1
fi

if [ -e "$1" ]; then
	vi $(find -name $1)
	exit 1
fi
