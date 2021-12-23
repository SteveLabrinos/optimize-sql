-- insert all the data from respondent_dim table, to the Index-Organized respondents table
insert /*+ APPEND */ into respondent_dim_iot
select *
  from respondent_dim;

commit;

-- insert all the data to the new structure Index-Organized table with respondent_state as a second column
insert /*+ APPEND */ into respondent_dim_iot (respondent_id, respondent_state, respondent_name, respondent_addr,
                                              respondent_city, respondent_zipcode, respondent_phone_num,
                                              respondent_gender, respondent_dob)
select respondent_id,
       respondent_state,
       respondent_name,
       respondent_addr,
       respondent_city,
       respondent_zipcode,
       respondent_phone_num,
       respondent_gender,
       respondent_dob
  from respondent_dim;