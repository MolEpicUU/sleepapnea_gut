# Project: Sleep apnea and gut microbiota
# Gabriel Baldanzi 

# Script to prepare data to be used in STATA

# Because AHI have a lower sample size than ODI and T90, we are imputing 
# missing AHI values in participants with valid ODI and T90 values

# STATA will be used to conducted the multiple imputation and the analyses with the 
# imputed data

# This script will prepare the data to be used at STATA


# Only the species identified in the model not adjusted for BMI will be included in this analysis 

# The Spearman's correlation in adjusted for the extended model covariates

  rm(list=ls())

  library(data.table)
  library(vegan)


  # Folders 
  work <- './work/'
  results.folder <-  './results/'

  # Import data
  pheno <- readRDS(paste0(work,"pheno_sleep_mgs_shannon.rds"))
  
  # Import findings from main model w/o BMI
  mgs.fdr.main <- readRDS(paste0(results.folder, "mgs.fdr.mainmodel.rds"))
  mgs.fdr.main <- unique(mgs.fdr.main$MGS)

  # Create dummy variables for factor variables 

  #Covariates 
  main.model <-   c("age", "Sex", "Alkohol","smokestatus","plate","BMI")
  extended.model <- c(main.model,"Fibrer","Energi_kcal" ,"leisurePA", 
                      "educat","placebirth","month")
  
  # Complete cases for the extended model on the analysis with T90/ODI
  pheno <- pheno[valid.t90=="yes",]
  setnames(pheno,"visit.month","month")
  
  cc <- complete.cases(pheno[,extended.model,with=F])
  pheno <- pheno[cc,]
  

  
  # Rename levels for better handling at STATA
  pheno[,leisurePA := factor(leisurePA, levels(leisurePA), labels = paste0("PA", 1:length(levels(leisurePA))))]
  pheno[,educat := factor(educat, levels(educat), labels = c("edu1","edu2","edu3", "edu4"))]
  pheno[month == "June.July", month := "Jun_Jul"]
  

  
  # Dummy variables
  temp.data <- pheno[,c("SCAPISid",extended.model),with=F]
  setDF(temp.data)
  rownames(temp.data) <- temp.data$SCAPISid
  temp.data <- as.data.frame(model.matrix(~.,temp.data[extended.model]))
  temp.data <- temp.data[,-which(names(temp.data)=="(Intercept)")]
  
  names.dummy.var <- names(temp.data)
  
  
  # Merge dummy variables 
  temp.data$SCAPISid <- rownames(temp.data)
  
  vars <- c("SCAPISid", "ahi", "t90", "odi","valid.ahi","valid.t90","shannon","WaistHip",mgs.fdr.main)
  
  pheno <- merge( pheno[, vars,with=F], temp.data, by="SCAPISid")
  
  pheno$monthJune <- NULL # all equal 0
  pheno$monthJuly <- NULL # all equal 0

# Makes species names shorter (some names were too long for STATA)

cutlast <- function(char,n){
  l <- nchar(char)
  a <- l-n+1
  return(substr(char,a,l))
}

  mgs.names.index <- grep("HG3A",names(pheno))
  names(pheno)[mgs.names.index] <- cutlast(names(pheno)[mgs.names.index],9)
  
 
  # Exporting in STATA friendly format 
  require(foreign)
  
  write.dta(pheno, paste0(work,"pheno.dta"))

  
  
  
  