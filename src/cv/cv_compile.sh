#!/bin/bash
OUTPUT_DIR="./output"
OUTPUT_NAME="cv_bgetraer"
INPUT_FILE="cv_template.tex"
mkdir -p $OUTPUT_DIR
lualatex --output-directory=$OUTPUT_DIR --jobname=$OUTPUT_NAME $INPUT_FILE
lualatex --output-directory=$OUTPUT_DIR --jobname=$OUTPUT_NAME $INPUT_FILE
