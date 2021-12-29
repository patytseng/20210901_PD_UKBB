rm -r /mnt/stsi/stsi1/ptseng/UKBB_Resources/ldpred2/corr
rm -r /mnt/stsi/stsi1/ptseng/UKBB_Resources/ldpred2/POS
mkdir /mnt/stsi/stsi1/ptseng/UKBB_Resources/ldpred2/corr
mkdir /mnt/stsi/stsi1/ptseng/UKBB_Resources/ldpred2/POS
for chrom in {1..22};
    do sbatch \
        --nodes=1 \
        --ntasks=1 \
        --cpus-per-task=20 \
        --time=7-00:00:00 \
        --mem=240GB \
        --partition=highmem \
        --export=chr=${chrom} \
        --job-name=LDpred2_corr_PD_chr${chrom} \
        --out=slurm_out/%x_jobID_%j \
        ldpred2_corr.qsub; \
done
