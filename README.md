# Glance at PRRSV-2

```bash
nextstrain build ingest
ls ingest/results/metadata.tsv
ls ingest/results/sequences.fasta
```

```bash
nextstrain build phylogenetic
nextstrain view phylogenetic/auspice
```

## Glance at Nextclade Dataset

Fetch the community dataset:

```bash
export DATASET_PATH=community/isuvdl/mazeller/prrsv2/orf5/yimim2023
export DATASET_NAME=nextclade_data/prrsv2/orf5.zip

nextclade3 dataset get \
    --name=${DATASET_PATH} \
    --output-zip=${DATASET_NAME} \
    --verbose
```

Run against query sequences

```bash
# export SEQUENCES=data/prrsv2.fasta
wget https://raw.githubusercontent.com/kvanderwaal/prrsv2_classification/refs/heads/main/reference.sequences.fasta
export SEQUENCES=reference.sequences.fasta

nextclade3 run \
    --input-dataset ${DATASET_NAME} \
    --output-tsv output/nextclade.tsv \
    --output-fasta output/alignment.fasta \
    --silent \
    ${SEQUENCES}

ls output/nextclade.tsv
```

Can tune alignment parameters:

```
# default values, check against pathogen.json again
nextclade3 run \
  --input-dataset nextclade/dataset.zip \
  --output-all test_out \
  ${SEQUENCES} \
  --min-length 100 \
  --penalty-gap-extend 0 \
  --penalty-gap-open 6 \
  --penalty-gap-open-in-frame 7 \
  --penalty-gap-open-out-of-frame 8 \
  --penalty-mismatch 1 \
  --score-match 3 \
  --retry-reverse-complement true \
  --no-translate-past-stop false \
  --gap-alignment-side left \
  --excess-bandwidth 9 \
  --terminal-bandwidth 50 \
  --allowed-mismatches 8 \
  --min-match-length 40 \
  --max-alignment-attempts 3 \
  --include-reference true \
  --include-nearest-node-info true
```

Examples:

* https://github.com/nextstrain/lassa/pull/47
* https://github.com/nextstrain/lassa/tree/main/nextclade/s_segment_sweep

Should be unclassified

* PV179105 to PV179253
* PV179365 to PV179414