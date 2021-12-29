for chrom in {1..22};
    do sbatch \
        --nodes=1 \
        --ntasks=1 \
        --cpus-per-task=16 \
        --time=7-00:00:00 \
        --mem=120GB \
        --partition=shared \
        --export=chrom=${chrom} \
        --job-name=PCa_regenie_step2.chr${chrom} \
        --out=slurm_logs/%x.jobID_%j \
        PCa_regenie_step2.qsub;
done