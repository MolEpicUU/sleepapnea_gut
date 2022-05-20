# sleepapnea_gut

### "Obstructive sleep apnea is associated with specific gut microbiota species and functions in the population-based Swedish CardioPulmonary bioImage Study".

***

#### Last update: 2022-May-20

 

#### In this study, we investigated the association between 3 obstructive sleep apnea (OSA) parameters and the gut microbiota composition in participants from SCPAPIS-Uppsala. Scripts to be run in R (version tested: 4.1.1), except for the multiple imputation that should be run in Stata (version tested: 15.1). 

The following R packages were used: 
ape (version 5.5)
data.table (version 1.14.2);
fgsea (version 1.18.0); 
Hmisc (version 4.6-0); 
parallel (version 4.1.1); 
ppcor (version 1.1); 
sjmisc (version 2.8.7); 
tidyverse (version 1.3.1); 
vegan (version 2.5-7).

##### Scripts meant to be run in the order specified below. 

* 00_data.preparation/datapreparation.R : creates folder for working files and results. It also criates new variables that are used in subsequent analyses, it excludes CPAP users, and calculates the Shannon diversity index
* 0_functions: Folder that contains functions to be used in subsequent analyses. These scripts don't need to be run separately. They will be called from other scripts. 
* 1_cor_shannon/cor_osa_shannon.R : Spearman's correlation between OSA parameters and Shannon index using two set of covariates (main model and extended model)
* 2_beta.diversity/calculate_braycurtis.R : calculates the Bray-Curtis (BC) dissimilarity matrix and performs the principal coordinate analyses. 
* 2_beta.diversity/permanova_main.R : PERMANOVA analysis between the OSA parameters and the BC matrix.
* 2_beta.diversity/pairwise : this folder contain 3 scripts (perma_pairwise_ahi.R, perma_pairwise_odi.R, perma_pairwise_t90.R) to perform the pairwise PERMANOVA for groups of OSA severity based on AHI, T90 or ODI. 
* 3_correlation : this folder contains the scripts to run the main analyses and sensitivity analyses for the Spearman's correlations of AHI, T90 and ODI with the gut microbiota species relative abundance. All the scripts can be run in the appropriate order by running the script "root_script.R". 
* 4_imputation : This folder contains the scripts to investigate the Spearman's correlations of AHI with species abundance after imputation of missing AHI values. Start with "pre.imputation.R" (run in R). Next, run "imputation_ahi.do" in STATA. Lastly, run "p.adjust.R" in R
* 5_hb_stratified/cor_stratified_hb.R : Spearman's correlations of T90 and ODI with specific species stratified by two groups of hemoglobin level (low and high). 
* 6_enrichment_GMM/enrich_GMM.R : Enrichment for gut metabolic modules in the associations between the OSA parameters and the species relative abundance. Analysis stratified by the direction of the associations (positive or negative) 
* 7_cor_health.outcomes/cor_mgs.gmm_bphb.R : Spearman's correlations of specific species and gut metabolic modules with systolic blood presssure, diastolic blood pressure, and glycated hemoglobin. Two models were investigated: OSA adjusted and OSA+BMI adjusted. 


##### Test datasets 
    
* input/pheno_sleep_mgs.rds : test data set containing 600 observations and 50 metagenomics species 
* input/MGS_HG3A.GMMs2MGS.R : test list of pathways/modules for the pathway enrichment analysis (6_enrichment_GMM/enrich_GMM.R)


##### Installation guide and Demo

* To run the entire code, one needs the softwares R (https://www.r-project.org/) and Stata (https://www.stata.com/). The following packages should be installed in R: ape, data.table, fgsea,
Hmisc, parallel, ppcor, sjmisc (version 2.8.7), tidyverse, vegan. No add-ons to Stata are needed. 

* Download all folders into one master folder. This master folder should be set as the working directory for both R and Stata. 

* In R:
     *  Run script 00_data.preparation/datapreparation.R.    
output: 

