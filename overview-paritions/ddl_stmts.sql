-- Table creation like candybar historical data, with partitioning for every year
create table candyhist_part
(
  respondent_id        number(9, 0),
  respondent_name      varchar2(100 char) not null,
  respondent_addr      varchar2(100 char),
  respondent_city      varchar2(100 char),
  respondent_state     varchar2(2 char),
  respondent_zipcode   varchar2(5 char),
  respondent_phone_num varchar2(14 char),
  respondent_gender    varchar2(1 char),
  respondent_dob       date,
  candybar_mfr_id      number(9, 0),
  candybar_mfr_name    varchar2(50 char)  not null,
  candybar_id          number(9, 0),
  candybar_name        varchar2(50 char)  not null,
  candybar_weight_oz   number(5, 2),
  survey_date          date,
  survey_year          number(4, 0)       not null,
  taste_rating         number(5, 2),
  appearance_rating    number(5, 2),
  texture_rating       number(5, 2),
  overall_rating       number(5, 2),
  likelihood_purchase  number(5, 2),
  nbr_bars_consumed    number(5, 0)
) partition by list
(
  survey_year
)
(
  partition p_2004 values (2004),
  partition p_2005 values (2005),
  partition p_2006 values (2006),
  partition p_2007 values (2007),
  partition p_2008 values (2008),
  partition p_2009 values (2009),
  partition p_2010 values (2010),
  partition p_2011 values (2011),
  partition p_2012 values (2012),
  partition p_2013 values (2013),
  partition p_2014 values (2014)
);
