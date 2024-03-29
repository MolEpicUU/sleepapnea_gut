# Project: Sleep apnea and gut microbiota
# Gabriel Baldanzi 

# This code will investigate pairwise comparison between groups 
# of different AHI severity

# Preparation 
source('2_beta.diversity/pairwise/pre_pairwise.R')

  # Importing data
  dades <- copy(pheno[valid.ahi=="yes",])

# Making sure that BC and dataset have the same order of observations 
  BC <- BC[dades$SCAPISid,dades$SCAPISid]
  
  dades <-  dades[match(rownames(BC),dades$SCAPISid),]
  

  # Running PERMANOVA in parallel ####
  
  dades[OSAcat=="No OSA", OSAcat:="noOSA"]
  dades[,OSAcat := factor(OSAcat, levels = c("noOSA", "Mild", "Moderate", "Severe"), 
                          labels = c("noOSA", "Mild", "Moderate", "Severe"))]
  
  list.res <- pairwise.perma.fun(outcome="BC", group_var="OSAcat", covari=main.model, data=dades, nodes=16)
  

  saveRDS(list.res,file=paste0(results.folder,"pairwise.perma.results_ahi.rds"))
#---------------------------------------------------------------------------#

  # Produce a final summary results table with FDR-p-values 
  
  list.res = readRDS(paste0(results.folder,"pairwise.perma.results_ahi.rds"))
  
  list.res$table <- clean.res(list.res[1:6]) 
  
  saveRDS(list.res,file=paste0(results.folder,"pairwise.perma.results_ahi.rds"))