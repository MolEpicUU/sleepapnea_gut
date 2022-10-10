# Project: Sleep apnea and gut microbiota
# Gabriel Baldanzi 


# This script performs the Spearman's correlation between the species that were 
# associated with T90/ODI and the health outcomes SBP/DPB/Hb1Ac in SCAPIS-Uppsala participants


# SBP = systolic blood pressure 
# DBD = diastolic blood pressure
# Hb1Ac = glycated hemoglobin

  library(data.table)

  # Folders 
  results.folder <-  './results/'
  work <- './work/'
  

  # Function
  source("0_functions/Spearman.correlation.function.R") # partial Spearman's correlation function

  # Import data
  pheno <- readRDS(paste0(work,"pheno_sleep_mgs_shannon.rds"))
  

  # Import the T90/ODI-associated species 
  ext.res <- fread(paste0(results.folder,"cor2_all.var_mgs.tsv"))
  mgs.neg = unique(ext.res[rho<0 & q.value<0.05, MGS])
  mgs.pos = unique(ext.res[rho>0 & q.value<0.05, MGS])
  t90.neg = unique(ext.res[exposure =="t90" & rho<0 & q.value<0.05, MGS])
  t90.pos = unique(ext.res[exposure =="t90" & rho>0 & q.value<0.05, MGS])
  odi.neg = unique(ext.res[exposure =="odi" & rho<0 & q.value<0.05, MGS])
  odi.pos = unique(ext.res[exposure =="odi" & rho>0 & q.value<0.05, MGS])
  
  pheno[,mgs.pos:=sum(.SD), .SDcols = mgs.pos, by = SCAPISid]
  pheno[,mgs.neg:=sum(.SD), .SDcols = mgs.neg, by = SCAPISid]
  pheno[,t90.pos:=sum(.SD), .SDcols = t90.pos, by = SCAPISid]
  pheno[,t90.neg:=sum(.SD), .SDcols = t90.neg, by = SCAPISid]
  pheno[,odi.pos:=sum(.SD), .SDcols = odi.pos, by = SCAPISid]
  pheno[,odi.neg:=sum(.SD), .SDcols = odi.neg, by = SCAPISid]
  
  mgs.fdr <- c(mgs.pos,mgs.neg)
  
  
  # Covariates 
  covariates <- c("age", "Sex", "Alkohol","smokestatus",
                  "Fibrer","Energi_kcal" ,"leisurePA", "placebirth",
                  "plate","t90","ahi","odi")
  
  # In the analysis with SBP and DBP, we excluded participants that self-reported
  # medication use for hypertension 
  # In the analysis with HbA1c, we excluded participants with self-reported 
  # medication use for diabetes 
  
  # Correlation of significant species with SBP and DBP ####
  
  outcomes = c("SBP_Mean", "DBP_Mean")
  
  temp.data = pheno[!is.na(SBP_Mean) & !is.na(DBP_Mean),]
  
  res.bp <- lapply(outcomes,spearman.function, 
                   x1=c(mgs.fdr,"mgs.neg","mgs.pos","t90.pos","t90.neg","odi.pos","odi.neg"),
                   covari = covariates,
                   data = temp.data[hypermed=="no",])
  
  res.bp <- do.call(rbind,res.bp)
  
  # Correlation with HbA1c 
  
  outcomes = c("Hba1cFormattedResult")
  
  temp.data = pheno[!is.na(Hba1cFormattedResult),]
  
  res.hb <- lapply(outcomes,spearman.function, 
                   x1=c(mgs.fdr,"mgs.neg","mgs.pos","t90.pos","t90.neg","odi.pos","odi.neg"),
                   covari = covariates,
                   data = temp.data[diabmed=="no",])
  
  res.hb <- do.call(rbind, res.hb)
  
  res.osa <- rbind(res.bp, res.hb)
  
  # Multiple testing adjustment 
  
  setDT(res.osa)
  res.osa[x=="SBP_Mean", q.value := p.adjust(p.value,method = "BH")]
  res.osa[x=="DBP_Mean", q.value := p.adjust(p.value,method = "BH")]
  res.osa[x=="Hba1cFormattedResult", q.value := p.adjust(p.value,method = "BH")]
  
  res.osa[,model:="OSA model"]
  
  
  
  # OSA+BMI adjusted ####
  
  # Model further adjusted for BMI 
  
  covariates.bmi = c(covariates, "BMI")
  
  # Correlation with SBP and DBP
  
  outcomes = c("SBP_Mean", "DBP_Mean")
  
  temp.data = pheno[!is.na(SBP_Mean) & !is.na(DBP_Mean),]
  
  res.bp <- lapply(outcomes,spearman.function, 
                   x1=c(mgs.fdr,"mgs.neg","mgs.pos","t90.pos","t90.neg","odi.pos","odi.neg"),
                   covari = covariates.bmi,
                   data = temp.data[hypermed=="no",])
  
  res.bp <- do.call(rbind,res.bp)
  
  # Correlation with HbA1c ####
  
  outcomes = c("Hba1cFormattedResult")
  
  temp.data = pheno[!is.na(Hba1cFormattedResult),]
  
  res.hb <- lapply(outcomes,spearman.function, 
                   x1=c(mgs.fdr,"mgs.neg","mgs.pos","t90.pos","t90.neg","odi.pos","odi.neg"),
                   covari = covariates.bmi,
                   data = temp.data[diabmed=="no",])
  
  res.hb <- do.call(rbind, res.hb)
  
  res.osa.bmi <- rbind(res.bp, res.hb)
  
  
  # Multiple testing adjustment 
  
  setDT(res.osa.bmi)
  res.osa.bmi[x=="SBP_Mean", q.value := p.adjust(p.value,method = "BH")]
  res.osa.bmi[x=="DBP_Mean", q.value := p.adjust(p.value,method = "BH")]
  res.osa.bmi[x=="Hba1cFormattedResult", q.value := p.adjust(p.value,method = "BH")]
  
  res.osa.bmi[,model:="OSA and BMI adjusted"]
  
  
  
  # Save results 
  
  res <- rbind(res.osa, res.osa.bmi)
  
  setnames(res, c("x","exposure"), c("MGS_features", "outcomes"))
  
  fwrite(res, file=paste0(results.folder, "cor_mgs.gmm_bphb.tsv"))
  
  