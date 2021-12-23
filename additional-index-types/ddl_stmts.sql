-- crate a B-Tree index for the names of the respondents
create index ix_respdim_respname on respondent_dim(respondent_name) parallel;

-- crate a function-based B-Tree index for the names of the respondents
create index ix_respdim_upperrespname on respondent_dim(upper(respondent_name)) parallel;

-- create a function-based index with an expression involving 2 columns
create index ix_cndfact_troar on candybar_fact(100 * (taste_rating / overall_rating)) parallel;

-- to create a Bitmap Join index the dim table must have a primary key (already placed on respondent_id)
-- then an index in the columns of the subsetting (respondent_state)
create index ix_respdim_respstate on respondent_dim(respondent_state) parallel;
-- then crate the Bitmap-Join index
create bitmap index bmji_candresp_state on candybar_fact(rd.respondent_state)
  from candybar_fact cf, respondent_dim rd
    where cf.respondent_id = rd.respondent_id;

-- create an Index-Organized table for respondents
create table respondent_dim_iot
(
  respondent_id        number(9)          not null
    constraint pk_respondent_dim_iot
      primary key,
  respondent_name      varchar2(100 char) not null,
  respondent_addr      varchar2(100 char),
  respondent_city      varchar2(100 char),
  respondent_state     varchar2(2 char),
  respondent_zipcode   varchar2(5 char),
  respondent_phone_num varchar2(14 char),
  respondent_gender    varchar2(1 char),
  respondent_dob       date
) organization index;

-- create an additional index on the respondent_state
create index ix_respdimiot_respstate on respondent_dim_iot(respondent_state) parallel;

declare
  schema_owner constant varchar2(20 char) := 'LAMPR';
begin
  dbms_stats.gather_table_stats(ownname => schema_owner,
                                tabname => 'RESPONDENT_DIM_IOT',
                                estimate_percent => dbms_stats.auto_sample_size,
                                degree => dbms_stats.default_degree);
end;

-- recreate the Index-Organized table with OVERFLOW after respondent_state (moved as 2nd column)
drop table respondent_dim_iot;

create table respondent_dim_iot
(
  respondent_id        number(9)          not null
    constraint pk_respondent_dim_iot
      primary key,
  respondent_state     varchar2(2 char),
  respondent_name      varchar2(100 char) not null,
  respondent_addr      varchar2(100 char),
  respondent_city      varchar2(100 char),
  respondent_zipcode   varchar2(5 char),
  respondent_phone_num varchar2(14 char),
  respondent_gender    varchar2(1 char),
  respondent_dob       date
) organization index
  including respondent_state overflow;
-- also recreate the index and run the statistics for the table


