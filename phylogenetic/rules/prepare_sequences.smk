"""
This part of the workflow prepares sequences for constructing the phylogenetic tree.

REQUIRED INPUTS:

    metadata    = results/metadata.tsv
    sequences   = results/sequences.fasta
    reference   = ../shared/reference.fasta

OUTPUTS:

    prepared_sequences = results/prepared_sequences.fasta

This part of the workflow usually includes the following steps:

    - augur index
    - augur filter
    - augur align
    - augur mask

See Augur's usage docs for these commands for more details.
"""

rule filter:
    """
    Filtering to
      - {params.sequences_per_group} sequence(s) per {params.group_by!s}
      - from {params.min_date} onwards
      - excluding strains in {input.exclude}
      - minimum genome length of {params.min_length} (50% of Zika virus genome)
    """
    input:
        sequences = "results/sequences.fasta",
        metadata = "results/metadata.tsv",
        exclude = resolve_config_path(config["filter"]["exclude"]),
        include = resolve_config_path(config["filter"]["include"]),
    output:
        sequences = "results/filtered.fasta"
    params:
        strain_id = config.get("strain_id_field", "strain"),
        min_length = config["filter"]["min_length"],

    log:
        "logs/filter.txt",
    benchmark:
        "benchmarks/filter.txt"
    shell:
        r"""
        exec &> >(tee {log:q})

        augur filter \
            --sequences {input.sequences:q} \
            --metadata {input.metadata:q} \
            --metadata-id-columns {params.strain_id:q} \
            --exclude {input.exclude:q} \
            --include {input.include:q} \
            --output-sequences {output.sequences:q} \
            --min-length {params.min_length:q}
        """

rule align:
    """
    Aligning sequences to {input.reference}
      - filling gaps with N
    """
    input:
        sequences = "results/filtered.fasta",
        reference = resolve_config_path(config["reference"]),
    output:
        alignment = "results/aligned.fasta"
    log:
        "logs/align.txt",
    benchmark:
        "benchmarks/align.txt"
    threads: 8
    shell:
        r"""
        exec &> >(tee {log:q})

        augur align \
            --nthreads {threads} \
            --sequences {input.sequences:q} \
            --reference-sequence {input.reference:q} \
            --output {output.alignment:q} \
            --fill-gaps \
            --remove-reference
        """


rule filter2:
    """
    Filtering to
      - {params.sequences_per_group} sequence(s) per {params.group_by!s}
      - from {params.min_date} onwards
      - excluding strains in {input.exclude}
      - minimum genome length of {params.min_length} (50% of Zika virus genome)
    """
    input:
        sequences = "results/aligned.fasta",
        metadata = "results/metadata.tsv",
        include = resolve_config_path(config["filter"]["include"]),
    output:
        sequences = "results/aligned2.fasta"
    params:
        strain_id = config.get("strain_id_field", "strain"),
        min_length = config["filter"]["min_length"],
    log:
        "logs/filter.txt",
    benchmark:
        "benchmarks/filter.txt"
    shell:
        r"""
        exec &> >(tee {log:q})

        augur filter \
            --sequences {input.sequences:q} \
            --metadata {input.metadata:q} \
            --metadata-id-columns {params.strain_id:q} \
            --include {input.include:q} \
            --output-sequences {output.sequences:q} \
            --min-length {params.min_length:q}
        """