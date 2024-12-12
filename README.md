<!-- <h1>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/images/nf-core-strelkasomatic_logo_dark.png">
    <img alt="nf-core/strelkasomatic" src="docs/images/nf-core-strelkasomatic_logo_light.png">
  </picture>
</h1>

[![GitHub Actions CI Status](https://github.com/nf-core/strelkasomatic/actions/workflows/ci.yml/badge.svg)](https://github.com/nf-core/strelkasomatic/actions/workflows/ci.yml)
[![GitHub Actions Linting Status](https://github.com/nf-core/strelkasomatic/actions/workflows/linting.yml/badge.svg)](https://github.com/nf-core/strelkasomatic/actions/workflows/linting.yml)[![AWS CI](https://img.shields.io/badge/CI%20tests-full%20size-FF9900?labelColor=000000&logo=Amazon%20AWS)](https://nf-co.re/strelkasomatic/results)[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![nf-test](https://img.shields.io/badge/unit_tests-nf--test-337ab7.svg)](https://www.nf-test.com) -->

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A524.04.2-23aa62.svg)](https://www.nextflow.io/)
<!-- [![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/) -->
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Seqera Platform](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Seqera%20Platform-%234256e7)](https://cloud.seqera.io/launch?pipeline=https://github.com/nf-core/strelkasomatic)

<!-- [![Get help on Slack](http://img.shields.io/badge/slack-nf--core%20%23strelkasomatic-4A154B?labelColor=000000&logo=slack)](https://nfcore.slack.com/channels/strelkasomatic)[![Follow on Twitter](http://img.shields.io/badge/twitter-%40nf__core-1DA1F2?labelColor=000000&logo=twitter)](https://twitter.com/nf_core)[![Follow on Mastodon](https://img.shields.io/badge/mastodon-nf__core-6364ff?labelColor=FFFFFF&logo=mastodon)](https://mstdn.science/@nf_core)[![Watch on YouTube](http://img.shields.io/badge/youtube-nf--core-FF0000?labelColor=000000&logo=youtube)](https://www.youtube.com/c/nf-core) -->

## Introduction

**nf-core/strelkasomatic** is a bioinformatics pipeline that calls somatic mutations from BAM files using Illumina's Manta and Strelka2.

There are 2 steps involved

1. [Manta](https://github.com/Illumina/manta)
  - Manta to call candidate small Indels, which can then be used to call somatic SNVs and Indels in the Strelka step (along with a "results" directory under `"manta_out/${sample_id}"`, details in [docs/output.md](docs/output.md))
2. [Strelka](https://github.com/Illumina/strelka)
  - Strelka to call the final SNVs and Indels VCF files, output files are published in a "results" directory under `"strelka_out/${sample_id}"`, details in [docs/output.md](docs/output.md)

## Dependencies

- Nextflow >= 24.04.2 required

> [!NOTE]
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how to set-up Nextflow.

- python 2.6+

## Installation

```
git clone git@github.com:Phuong-Le/StrelkaSomatic.git
```


## Usage

> [NOT PUBLIC YET] Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline) with `-profile test` before running the workflow on actual data.

The input sample sheet should be either in a tab delimited format (extension must be .tsv), or comma delimited format (extension must be .csv), like [samplesheet.tsv](assets/samplesheet.tsv). Your input should contain the following columns (column names must be accurate but no need to be in this order, redundant columns will be ignored)


| Column    | Description                                                                                                                                                                            |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `sample_id`  | sample ID, must be unique |
| `match_normal_id` |  ID for your match normal sample |                                                            |
| `bam` | bam file for `sample_id`, must exist |                                                       |
| `bai` | tabix index file for `bam`, must exist |
| `bam_match` | bam file for `match_normal_id`, must exist |
| `bai_match` | tabix index file for `bam_match`, must exist |

Please find the detailed instructions to run the pipeline, including the input parameters in [docs/usage.md](docs/usage.md). You can run the pipeline using:

```bash

nextflow run /path/to/SangerSomaticMutation/main.nf \
   -profile <docker/singularity/.../institute> \
   --input /path/to/samplesheet.csv \
   --fasta /path/to/fasta/genome.fa \
   --fai /path/to/fai/genome.fa.fai \
   --outdir /path/to/outdir
```

If using igenomes please add the following to the `nextflow run`, note that igenomes do not have the tabix index file for `$fasta` so you will have to specify this, for example

```bash
--igenomes_ignore false \
--fai /path/to/fai/genome.fa.fai \
--genome your_genome_label
```

> [!WARNING]
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_; see [docs](https://nf-co.re/docs/usage/getting_started/configuration#custom-configuration-files).


## Sanger users

Sanger users can run the pipeline as follows. Please refer to [docs/sanger.md](docs/sanger.md) to ensure you have the right set up.

```bash
module load cellgen/nextflow/24.10.2

outdir=/path/to/outdir
workdir=/path/to/working_directory # where a `work` directory is created
script=/path/to/StrelkaSomatic/main.nf
mkdir -p $workdir
input=/path/to/samplesheet.tsv
fasta=/path/to/fasta/genome.fa
fai=/path/to/fasta/index/genome.fa.fai

config=/path/to/StrelkaSomatic/conf/sanger_lfs.config

bsub -cwd $workdir -q long -o %J.o -e %J.e -R'span[hosts=1] select[mem>10000] rusage[mem=10000]' -M10000 -env "all" \
    "nextflow run $script --input ${input} --outdir ${outdir} --fasta ${fasta} --fai ${fai} -resume"
```

or as follows

```bash
module load cellgen/nextflow/24.10.2

outdir=/path/to/outdir
workdir=/path/to/working_directory # where a `work` directory is created
script=/path/to/StrelkaSomatic/main.nf
mkdir -p $workdir
input=/path/to/samplesheet.tsv
custom_genome_base=/lustre/scratch124/casm/team78pipelines/canpipe/live/ref/Homo_sapiens # please let me know if you're using a different genome so I can update the config for you
use_custom_genome=true
genome=GRCh38_full_analysis_set_plus_decoy_hla

config=/path/to/StrelkaSomatic/conf/sanger_lfs.config

bsub -cwd $workdir -q long -o %J.o -e %J.e -R'span[hosts=1] select[mem>10000] rusage[mem=10000]' -M10000 -env "all" \
    "nextflow run $script --input ${input} --outdir ${outdir} --use_custom_genome ${use_custom_genome} --custom_genome_base ${custom_genome_base} --genome ${genome} -resume"
```


## Pipeline output

To see the results of an example test run with a full size dataset refer to the [results](https://nf-co.re/strelkasomatic/results) tab on the nf-core website pipeline page.
For more details about the output files and reports, please refer to the
[output documentation](https://nf-co.re/strelkasomatic/output).

## Credits

nf-core/strelkasomatic was originally written by Phuong Le.

We thank the following people for their extensive assistance in the development of this pipeline:

Stephen Fitzgerald

<!-- TODO nf-core: If applicable, make list of people who have also contributed -->

## Citations

<!-- TODO nf-core: Add citation for pipeline after first release. Uncomment lines below and update Zenodo doi and badge at the top of this file. -->
<!-- If you use nf-core/sangersomatic for your analysis, please cite it using the following doi: [10.5281/zenodo.XXXXXX](https://doi.org/10.5281/zenodo.XXXXXX) -->

<!-- TODO nf-core: Add bibliography of tools and data used in your pipeline -->

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.
