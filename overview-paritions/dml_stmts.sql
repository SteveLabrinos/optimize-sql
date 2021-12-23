insert into candyhist_part(respondent_id, respondent_name, respondent_addr, respondent_city, respondent_state,
                           respondent_zipcode, respondent_phone_num, respondent_gender, respondent_dob, candybar_mfr_id,
                           candybar_mfr_name, candybar_id, candybar_name, candybar_weight_oz, survey_date, survey_year,
                           taste_rating, appearance_rating, texture_rating, overall_rating, likelihood_purchase,
                           nbr_bars_consumed)
select rd.respondent_id,
       rd.respondent_name,
       rd.respondent_addr,
       rd.respondent_city,
       rd.respondent_state,
       rd.respondent_zipcode,
       rd.respondent_phone_num,
       rd.respondent_gender,
       respondent_dob,
       d.candybar_mfr_id,
       d.candybar_mfr_name,
       cd.candybar_id,
       cd.candybar_name,
       cd.candybar_weight_oz,
       dd.survey_date,
       dd.survey_year,
       cf.taste_rating,
       cf.appearance_rating,
       cf.texture_rating,
       cf.overall_rating,
       cf.likelihood_purchase,
       cf.nbr_bars_consumed
  from candybar_fact cf
         inner join date_dim dd on dd.survey_date = cf.survey_date
         inner join candybar_dim cd on cd.candybar_id = cf.candybar_id
         inner join candymfr_dim d on d.candybar_mfr_id = cd.candybar_mfr_id
         inner join respondent_dim rd on rd.respondent_id = cf.respondent_id;
