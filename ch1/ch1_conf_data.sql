-- date_dim
insert into date_dim (survey_date, survey_year, survey_month)
select distinct survey_date, survey_year, extract(month from survey_date) as survey_month
  from candybar_historical_data;

-- respondent_dim
insert into respondent_dim (respondent_id, respondent_name, respondent_addr, respondent_city, respondent_state,
                            respondent_zipcode, respondent_phone_num, respondent_gender, respondent_dob)
select respondent_id,
       respondent_name,
       respondent_addr,
       respondent_city,
       respondent_state,
       respondent_zipcode,
       respondent_phone_num,
       respondent_gender,
       respondent_dob
  from (
         select a.*, row_number() over (partition by respondent_id order by respondent_name desc) rn
           from (
                  select distinct respondent_id,
                                  respondent_name,
                                  respondent_addr,
                                  respondent_city,
                                  respondent_state,
                                  respondent_zipcode,
                                  respondent_phone_num,
                                  respondent_gender,
                                  respondent_dob
                    from candybar_historical_data) a)
 where rn = 1;

-- candymfr_dim
insert into candymfr_dim (candybar_mfr_id, candybar_mfr_name)
select distinct candybar_mfr_id, candybar_mfr_name
  from candybar_historical_data;

-- candybar_dim
insert into candybar_dim (candybar_id, candybar_name, candybar_mfr_id, candybar_weight_oz)
select distinct candybar_id, candybar_name, candybar_mfr_id, candybar_weight_oz
  from candybar_historical_data;


-- candybar_fact
insert into candybar_fact (respondent_id, candybar_id, survey_date, taste_rating, appearance_rating, texture_rating,
                           overall_rating, likelihood_purchase, nbr_bars_consumed)
select respondent_id,
       candybar_id,
       survey_date,
       taste_rating,
       appearance_rating,
       texture_rating,
       overall_rating,
       likelihood_purchase,
       nbr_bars_consumed
  from candybar_historical_data;

commit;
-- after all the tables have the required date perform the ddl stmt (not in c1_ddl in order to run scripts consequentially)
drop table candybar_historical_data;


