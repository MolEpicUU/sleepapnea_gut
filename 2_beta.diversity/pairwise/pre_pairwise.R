# Script to prepare the data for the pairwise PERMANOVA for groups of AHI/T90/ODI 

  # Loading packages
  library(data.table)
  library(vegan)
  library(parallel)

  # Folders
  results.folder = './results/'

  work <- './work/'
  
  # Import data
  pheno <- readRDS(paste0(work,"pheno_sleep_mgs_shannon.rds"))

  
  # Functions 
  source('0_functions/perma.pairwise.fun.R')

  #Covariates 
  main.model<-   c("age", "Sex", "Alkohol","smokestatus","plate", "BMI")
  
  # Importing BC matrix 
  BC = fread(paste0(work,'BCmatrix.tsv'))
  BC_rownames <- BC$rownames
  BC$rownames <- NULL
  
  BC <-  as.matrix(BC)
  colnames(BC) <- rownames(BC) <- BC_rownames
  
