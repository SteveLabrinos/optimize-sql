-- check the time it takes to aggregate on the simple table
-- 2sec 400 ms
select sum(taste_rating) as tot_taste
  from candybar_historical_data;


select sum(taste_rating) as tot_taste
  from candybar_fact;

-- date_dim
select *
  from date_dim;

select distinct survey_date, survey_year, extract(month from survey_date) as survey_month
  from candybar_historical_data;

-- respondent_dim
select *
  from respondent_dim;

select distinct respondent_id
  from candybar_historical_data;

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

select *
  from candybar_historical_data
 where respondent_id = 86
   and respondent_dob != to_date('1983-04-23', 'rrrr-mm-dd');

-- 1969-06-12 problematic date


-- candybar_dim
select *
  from candybar_dim;
-- 250 rows
select distinct candybar_id, candybar_name, candybar_mfr_id, candybar_weight_oz
  from candybar_historical_data;

-- candymfr_dim
select *
  from candymfr_dim;
-- 80 rows
select distinct candybar_mfr_id, candybar_mfr_name
  from candybar_historical_data;

-- candybar_fact
select *
  from candybar_fact;

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

-- test that the new db model works
select *
  from respondent_dim;

