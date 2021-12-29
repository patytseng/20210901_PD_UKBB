# Load packages bigsnpr and bigstatsr
library(bigsnpr)
library(stringr)
library(optparse)

# Obtaining chromosome number
option_list = list(
    make_option("--chromosome", type="integer", default=NULL, help="chromosome numbers"),
    make_option("--file", type="character", default=NULL, help="stats file"),
    make_option("--CHR", type="character", default="CHR", help="stats file chromosome column name"),
    make_option("--POS", type="character", default="POS", help="stats file base position column name"),
    make_option("--A0", type="character", default="A0", help="stats file reference allele column name"),
    make_option("--A1", type="character", default="A1", help="stats file effect allele column name")
)
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

if (is.null(opt$chr)){
    print_help(opt_parser)
    stop("At least one argument must be supplied (chromosome number).n", call.=FALSE)
}

if (is.null(opt$file)){
    print_help(opt_parser)
    stop("At least one argument must be supplied (stats file).n", call.=FALSE)
}

chr <- opt$chr

# Grabbing SNP IDs from stats file
print('Grabbing SNP IDs from stats file')
data <- read.csv(opt$file,sep=' ')
data <- data[,c(opt$CHR,opt$POS,opt$A0,opt$A1)]
names(data) <- c('CHR','POS','A0','A1')
data["INDEX"] = str_c(data$CHR,data$POS,data$A0,data$A1,sep="_")

# Formatting list
print('Finishing list of SNP IDs')
list_snp_id <- list()
for (val in chr) {
    subset <- data[(data$CHR == val),]
    list_snp_id <- append(list_snp_id, list(subset$INDEX))
}

# Read from BGEN, it generates .bk and .rds files
print('Reading from BGEN and generating bigSNP object with selected SNPs')
rds <- snp_readBGEN(
    bgenfiles = glue::glue("/mnt/stsi/stsi1/ptseng/UKBB_Resources/impute_impute4/bgen_links/ukb_imp_chr{chr}_v3.bgen", chr = chr),
    backingfile = "/scratch_ssd/temp",
    list_snp_id = list_snp_id,
    ncores = 1
)
