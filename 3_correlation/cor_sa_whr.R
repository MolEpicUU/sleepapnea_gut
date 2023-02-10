# Project: Sleep apnea and gut microbiota
# Gabriel Baldanzi 

  # This script performs the sensitivity analysis by additional adjustment 
  # for waist-hip ration to the extended model


  # This analysis only includes the species that were FDR significant in the extended model 
  # Import species names identified in the extended model 

  mgs.fdr  = readRDS(paste0(results.folder,'mgs.m1.rds'))
  
   

  # Correlations with gut microbiota species using the extended model

# Correlations

  res.whr <- lapply( c("t90","odi") , spearman.function, 
                          x1 = mgs.fdr,
                          covari = extended.model.whr,
                          data = pheno)

  res.whr  <- do.call(rbind,res.whr)
  
  setDT(res.whr)
  setnames(res.whr,"x","MGS")
  
  
  # Save results for the extended model
  fwrite(res.whr, file = paste0(results.folder,"cor.whr_all.var_mgs.tsv"))
  
  
  
  
  