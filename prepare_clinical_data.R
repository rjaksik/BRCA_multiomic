library('xlsx')

# Set Dataset Name
DatasetName <- 'TCGA_BRCA_Multiomic'

# Read clinical data
SampAnnot <- read.table('clinical.cart.2024-07-03/clinical.tsv', header = TRUE, sep = "\t", quote = '')

# Convert columns to numeric
SampAnnot$days_to_death <- as.numeric(SampAnnot$days_to_death)
SampAnnot$days_to_last_follow_up <- as.numeric(SampAnnot$days_to_last_follow_up)

# Calculate 2-year and 5-year survival 
calculate_survival <- function(data, Nyears) {
  survival_column <- ifelse(data$days_to_death >= Nyears * 365 | 
                            (is.na(data$days_to_death) & data$days_to_last_follow_up >= Nyears * 365), 
                            'Survived', 'Died')
  return(survival_column)
}
SampAnnot$Surv2yr <- calculate_survival(SampAnnot, 2)
SampAnnot$Surv5yr <- calculate_survival(SampAnnot, 5)

# Read additional annotation data
ExtraAnnot <- read.xlsx('nature11412-s2 Supplementary Tables 1-4.xls', 1)

# Merge the annotation data
SampAnnot <- merge(SampAnnot, ExtraAnnot, by.x = 'case_submitter_id', by.y = 'Complete.TCGA.ID', all.x = TRUE, all.y = FALSE)

# Set the factor for analysis
Factor <- 'Surv5yr'
