process manta {
    publishDir "${params.outdir}/manta_out/${meta.sample_id}", pattern: 'results', mode: params.publish_dir_mode

    input:
    tuple val(meta), path(bam), path(bai), path(bam_match), path(bai_match)
    path fasta
    path fai

    output:
    tuple val(meta), path(candidate_indels), path(candidate_indels_idx), emit: candidate_indels
    path 'results'

    script:
    candidate_indels = "results/variants/candidateSmallIndels.vcf.gz"
    candidate_indels_idx = "results/variants/candidateSmallIndels.vcf.gz.tbi"
    """
    rm -rf manta_out results
    mkdir manta_out
    ${projectDir}/bin/manta-1.6.0.centos6_x86_64/bin/configManta.py --normalBam ${bam_match} --tumorBam ${bam} --referenceFasta ${fasta} --runDir manta_out
    manta_out/runWorkflow.py -j ${task.cpus} -m local

    mv manta_out/results .
    rm -rf manta_out
    rm -r ${bam} ${bai} ${bam_match} ${bai_match} ${fasta} ${fai}
    """
}
