# Calculate Beta-diversity (Bray-Curtis dissimilarity)

# This script produces Bray-Curtis dissimilary matrix from the species abundance and 
# performs the Principal Coordinate Analysis (PCoA)

  library(data.table)
  library(vegan)
  library(ape)

    
  # # Defining folders
  input <- './imput/'
  work <- './work/'
  
  # Import data
  pheno <- readRDS(paste0(work,"pheno_sleep_mgs_shannon.rds"))
   
  # Pass species names to an object 
  species.names <- grep("HG3A",names(pheno),value=T)
  
  # Create a species matrix for participants with valid AHI and valid T90/ODI data
  MGSmatrix <- pheno[valid.ahi=="yes" | valid.t90 =="yes", species.names, with=F]
  rownames(MGSmatrix) <- pheno[valid.ahi=="yes" | valid.t90 =="yes", SCAPISid]
  
  # Create the Bray-Curtis matrix 
  
  BC <-  as.matrix(vegdist(MGSmatrix,method="bray")) # MGS as relative abundances
  
  rownames(BC) <- colnames(BC) <- rownames(MGSmatrix)
  
  
  
  # Principal coordinates analysis (PCoA)
  
  # Participants with valid AHI data 
  pcts <- pheno[valid.ahi=="yes",SCAPISid]
  pcoa.bray <- pcoa(BC[pcts, pcts])
  saveRDS(pcoa.bray, file = paste0(work,'pcoa_BC_AHI.rds'))
  
  # Participants with valid T90/ODI data 
  pcts <- pheno[valid.t90=="yes",SCAPISid]
  pcoa.bray <- pcoa(BC[pcts, pcts])
  saveRDS(pcoa.bray, file = paste0(work,'pcoa_BC_T90.ODI.rds'))
  
  # Save the BC matrix 
  BC.rownames <- rownames(BC)
    
  BC <- data.frame(BC)
  setDT(BC)
  
  BC[,rownames := BC.rownames]
  
  fwrite(BC, file = paste0(work, 'BCmatrix.tsv') )
