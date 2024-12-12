process strelka {
    publishDir "${params.outdir}/strelka_out/${meta.sample_id}", mode: params.publish_dir_mode

    input:
    tuple val(meta), path(candidate_indels), path(candidate_indels_idx), path(bam), path(bai), path(bam_match), path(bai_match)
    path fasta
    path fai

    output:
    path 'results'

    script:
    """
    rm -rf strelka_out results
    mkdir strelka_out
    ${projectDir}/bin/strelka-2.9.10.centos6_x86_64/bin/configureStrelkaSomaticWorkflow.py --normalBam ${bam_match} --tumorBam ${bam} --referenceFasta ${fasta} --indelCandidates ${candidate_indels} --runDir strelka_out
    strelka_out/runWorkflow.py -j ${task.cpus} -m local

    rm -r ${candidate_indels} ${candidate_indels_idx} ${bam} ${bai} ${bam_match} ${bai_match} ${fasta} ${fai}
    mv strelka_out/results .
    rm -rf strelka_out
    """
}
