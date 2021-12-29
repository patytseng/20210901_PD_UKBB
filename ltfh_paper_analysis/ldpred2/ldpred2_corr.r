# Load packages
library(bigsnpr)
library(bigassertr)
library(optparse)

# Obtaining chromosome number
option_list = list(
    make_option("--chr", type="integer", default=NULL, help="chromosome numbers"),
    make_option("--pos_dir", type="character", default=NULL, help="position file storage location"),
    make_option("--out", type="character", default=NULL, help="correlation file storage location")
)
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

if (is.null(opt$chr)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (chromosome number)", call.=FALSE)
}

chr <- opt$chr

# Attach the "bigSNP" object in R session
print('Grabbing bigSNP Object...')
obj.bigSNP <- snp_attach('/scratch_ssd/temp.rds')
obj.bigSNP$map$chromosome <- as.numeric(obj.bigSNP$map$chromosome)
# See how the file looks like
#str(obj.bigSNP, max.level = 2, strict.width = "cut")
print('Grabbing bigSNP Object... done')

# Get aliases for useful slots
G   <- obj.bigSNP$genotypes
CHR <- obj.bigSNP$map$chromosome
POS <- obj.bigSNP$map$physical.pos
NCORES <- nb_cores()

# Set individuals
set.seed(11235)
ind.val <- sample(nrow(G), 10000)

POS2 <- snp_asGeneticPos(CHR, POS, dir = opt$pos_dir, ncores = NCORES)

# Generate Correlation Info into File
ind.chr <- which(CHR == chr)

print('Starting to make LD Matrix')

runonce::save_run(
    snp_cor(
        G, ind.row = ind.val, ind.col = ind.chr,
        alpha = 1, infos.pos = POS2[ind.chr], size = 3 / 1000,
        ncores = NCORES
    ),
    file = paste0(opt$out,"/chr", chr, ".rds")
)