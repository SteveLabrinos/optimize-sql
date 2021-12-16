create table candymfr_dim
(
  candybar_mfr_id number(9, 0),
  candybar_mfr_name varchar2(50 char) not null,
  constraint pk_candymfr_dim primary key (candybar_mfr_id)
);

create table candybar_dim
(
  candybar_id        number(9, 0),
  candybar_name      varchar2(50 char) not null,
  candybar_mfr_id    number(9, 0),
  candybar_weight_oz number(5, 2),

  constraint pk_candybar_dim primary key (candybar_id),
  constraint fk_cddim_cdmfrdim_cdmfrid foreign key (candybar_mfr_id) references candymfr_dim (candybar_mfr_id)
);

create table date_dim
(
  survey_date date,
  survey_year number(4, 0) not null,
  survey_month number(2, 0) not null,

  constraint pk_date_dim primary key (survey_date)
);

create table respondent_dim
(
  respondent_id number (9, 0),
  respondent_name varchar2(100 char) not null,
  respondent_addr varchar2(100 char),
  respondent_city varchar2(100 char),
  respondent_state varchar2(2 char),
  respondent_zipcode varchar2(5 char),
  respondent_phone_num varchar2(14 char),
  respondent_gender varchar2(1 char),
  respondent_dob date,

  constraint pk_respondent_dim primary key (respondent_id)
);


create table candybar_fact
(
  respondent_id       number(9, 0),
  candybar_id         number(9, 0),
  survey_date         date,
  taste_rating        number(5, 2),
  appearance_rating   number(5, 2),
  texture_rating      number(5, 2),
  overall_rating      number(5, 2),
  likelihood_purchase number(5, 2),
  nbr_bars_consumed   number(5, 0),

  constraint pk_candybar_fact primary key (respondent_id, candybar_id, survey_date),

  constraint fk_cdf_cddim_cdid foreign key (candybar_id) references candybar_dim (candybar_id),
  constraint fk_cdf_ddim_svdate foreign key (survey_date) references date_dim (survey_date),
  constraint fk_cdf_rdim_rid foreign key (respondent_id) references respondent_dim (respondent_id)
);
