-------------------------------------------------------
-------------- Composite Partitions -------------------
-------------------------------------------------------

---------- What is a Composite partition --------------
-- Partitions containing partitions (i.e. subpartitions)
-- SURVEY_YEAR/RESPONDENT_GENDER -> List/List
-- SURVEY_DATE/LIKELIHOOD_PURCHASE -> Range/List
-- Can create partitions with non-existent values
-- Subpartition Template -> Saves coding each subpartition by hand
-- Can also override Subpartition Template as necessary


--------------- Example 1 - List/List -----------------
-- List Partition by SURVEY_YEAR
-- List Subpartition by RESPONDENT_GENDER
create table candy_part
(
  respondent_id     number,
  respondent_gender varchar2(100),
  survey_year       number
)
  partition by list
(
  survey_year
)
  subpartition by list
(
  respondent_gender
)
  subpartition template
(
  subpartition
  p_male
  values ('M', 'm'),
  subpartition
  p_female
  values ('F', 'f'),
  subpartition
  p_other
  values (default)
)
(
  partition p_old values (2004, 2005, 2006, 2007, 2008),
  partition p_new values (2009, 2010, 2011, 2012, 2013)
);


--------------- Example 2 - Range/List ----------------
-- Range Partition by SURVEY_DATE
-- List Subpartition by LIKELIHOOD_PURCHASE
create table candy_part
(
  respondent_id       number,
  respondent_gender   varchar2(100),
  survey_date         date,
  likelihood_purchase number
)
  partition by range
  (
   survey_date
    )
  subpartition by list
(
  likelihood_purchase
)
  subpartition template
(
  subpartition
  p_not_likely
  values (1, 2, 3),
  subpartition
  p_somewhat_likely
  values (4, 5, 6),
  subpartition
  p_very_likely
  values (7, 8, 9, 10)
)
(
  partition p_2004 values less than (date '2005-01-01'),
  partition p_2005 values less than (date '2006-01-01'),
  partition p_2006 values less than (date '2007-01-01'),
  partition p_rest values less than (maxvalue )
);



--------------- Example 3 - AUTOTRACE -----------------
-- Partition-Wise Joins
select count(*) as tot_rows
  from candyhist_part
 where survey_year = 2010;
-- SELECT (select)		1	3025.0	cpu_cost = 329290113, io_cost = 3017
-- SORT (SORT AGGREGATE)		1		cpu_cost = null, io_cost = null
-- UNKNOWN (PARTITION LIST SINGLE)		499955	3025.0	cpu_cost = 329290113, io_cost = 3017
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: CANDYHIST_PART;	499955	3025.0	cpu_cost = 329290113, io_cost = 3017