for degree in {1..5};
    do sbatch \
        --nodes=1 \
        --ntasks=1 \
        --cpus-per-task=16 \
        --time=7-00:00:00 \
        --mem=60GB \
        --partition=shared \
        --export=degree=${degree} \
        --job-name=king_degree_${degree}_unrelated \
        --out=slurm_logs/%x.jobID_%j \
        king_unrelated.qsub;
done