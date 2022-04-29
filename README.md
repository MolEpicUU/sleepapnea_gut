# sleepapnea_gut

### "Obstructive sleep apnea is associated with specific gut microbiota species and functions in the population-based Swedish CardioPulmonary bioImage Study".

***

#### Last update: 2022-April-29

 

#### In this study, we investigated the association between 3 OSA parameters and the gut microbiota composition in participants from SCPAPIS-Uppsala. Scripts to be run in R, except for the analysis with multiple imputation that should be run in STATA. 

##### Scripts should be run in the order specific below. 

* 00_data.preparation/datapreparation.R : Creates folder for working data and results. Criates new variables that will be used in subsequent analyses. Excludes CPAP users. Calculates the Shannon diversity index
* 0_functions: Folder that contains functions to be used in subsequent analyses.  
* 1_cor_shannon/cor_osa_shannon.R : Spearman's correlation between OSA parameters and Shannon index using two set of covariates (main model and extended model)
* 2_beta.diversity/calculate_braycurtis.R : calculates the Bray-Curtis (BC) dissimilarity matrix and performs the principal coordinate analyses. 
* 2_beta.diversity/permanova_main.R : PERMANOVA analysis between the OSA parameters and the BC matrix.
* 2_beta.diversity/pairwise : folder 3 scripts (perma_pairwise_ahi.R, perma_pairwise_odi.R, perma_pairwise_t90.R) to perform the pairwise PERMANOVA for groups of OSA severity based on AHI, T90 or ODI. 
* 3_correlation : folder contaning the script to run the main analysis and sensitivity analysis for the Spearman's correlation of AHI, T90 and ODI with gut microbiota species relative abundance. All scripts can be run in the appropriate order from the root_script.R
* 4_imputation : scripts to investigate the Spearman's correlation of AHI with species abundance after imputating missing AHI values. Start with pre.imputation.R (run in R). Next, run imputation_ahi_main.model.do in STATA. Last, p.adjust.R in R
* 5_hb_stratified/cor_stratified_hb.R : Spearman's correlation of T90 and ODI with specific species stratified by two groups of hemoglobin level (low and high). 
* 6_enrichment_GMM/enrich_GMM.R : Enrichment for gut metabolic modules in the associations between the OSA parameters and the species relative abundance. Analysis stratified by the direction of the associations (positive or negative) 
* 7_cor_gmm_metabolites/cor_gmm_met.R : Spearman's correlation between gut metabolic modules relative abundance and plasma metabolites. This is the only analysis that includes participants from SCAPIS-Uppsala and SCAPIS-Malmo
* 7_cor_gmm_subclass.R : Enrichment for metabolite groups (Metabolon's SUBPATHWAYS) in the associations between gut metabolic modules and plasma metabolites. Analysis stratified by the direction of the associations (positive or negative). 
* 8_cor_health.outcomes/cor_mgs.gmm_bphb.R : Spearman's correlation of specific species and gut metabolic modules with systolic blood presssure, diastolic blood pressure, and glycated hemoglobin. Two models were investigated: OSA adjusted and OSA+BMI adjusted. 
