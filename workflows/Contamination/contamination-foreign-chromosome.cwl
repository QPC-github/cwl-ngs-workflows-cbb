#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

label: contamination_foreign_chromosome
doc: "This workflow detect and remove foreign chromosome from a DNA fasta file"

inputs:
  query: string
  trans_fsa_gz: File
  threads: int
  out: string
  blastdb: Directory
  blastdb_name: string


outputs:
  blastn_tsv:
    outputSource: blastn/output
    type: File

steps:
  uncompress_noequal:
    run: ../../tools/basic/gzip.cwl
    label: Uncompress fasta
    in:
      d: { default: True }
      file: trans_fsa_gz
    out: [ output ]
  blastn:
    run: ../../tools/blast/blastn.cwl
    label: BlastN
    in:
      dbdir: blastdb
      db: blastdb_name
      query: uncompress_noequal/output
      num_threads: threads
      out: out
      outfmt: { default: "6 qseqid sseqid pident length mismatch gapopen qlen qstart qend sstart send evalue bitscore score"}
      word_size: { default: 28 }
      best_hit_overhang: { default: 0.1 }
      best_hit_score_edge: { default: 0.1 }
      evalue: { default: 0.0001 }
      min_raw_gapped_score: { default: 100 }
      penalty: { default: -5 }
      perc_identity: { default: 98.0 }
      task: { default: "megablast" }
      dust: { default: "yes" }
      soft_masking: { default: "true"}
    out: [output]

