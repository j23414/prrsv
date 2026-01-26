#! /usr/bin/env bash

set -euv

export DATASET_PATH=community/isuvdl/mazeller/prrsv2/orf5/yimim2023
export DATASET_NAME=nextclade_data/prrsv2/orf5.zip

export SEQUENCES=unclass.fasta


nextclade3 dataset get \
    --name=${DATASET_PATH} \
    --output-zip=${DATASET_NAME} \
    --verbose

nextclade3 run \
    --input-dataset ${DATASET_NAME} \
    --output-tsv nextclade.tsv \
    --silent \
    ${SEQUENCES}

