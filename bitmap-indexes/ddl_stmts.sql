-- Bitmap Index creation
create bitmap index bmix_cndfact_cndid on candybar_fact(candybar_id) parallel;

create bitmap index bmix_rspdim_rspgen on respondent_dim(respondent_gender) parallel;
