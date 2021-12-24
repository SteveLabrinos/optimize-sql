-------------------------------------------------------
---------------- Simple Partitions --------------------
-------------------------------------------------------

----------------- List Partitions ---------------------
------------ What is a List partition -----------------
-- Creates partitions using discrete values of a single column
-- Overview Example: SURVEY_YEAR values 2005, 2006
-- Partition can be defined using one or more values: VALUES(2004, 2005)
-- Can create partitions with non-existent values
-- DEFAULT keyword -> unhandled values stored in default partition
-- Each partition can be in a separate tablespace (TABLESPACE keyword)
-- WHERE Clause contains partitions columns -> Partition Pruning


----------- Creating a List partition -----------------
--list_partitions::=
-- partitions by list (column) ->
---- ({partition [partition] list_values_clause -> table_partition_description}, )

--list_values_clause::=
---- values (default | (literal | null))


---------- Examples of List partitions ----------------
-- syntax example
create table candy_part
(
  respondent_id   number,
  respondent_name varchar2(100),
  survey_year     number
)
-- partition syntax
  partition by list
(
  survey_year
)
(
  partition p_2004 values (2004),
  partition p_567 values (2005, 2006, 2007),
  partition p_def values (default)
);


------------ Adding a List partition ------------------
-- How to add a partition in a table that has already been partitioned by list
-- Can add additional partitions at later date
---- Use ALTER TABLE statement's ADD PARTITION Clause
---- Adding 2018 partition
alter table candyhist_part
  add partition p_2018 values (2018);
-- The statement is different if the default partition exists on the table
alter table candyhist_part
  split partition p_def values (2020, 2021)
    into (partition p_202021, partition p_def);


-- ALL_TAB_PARTITIONS
select *
  from all_tab_partitions
 where table_owner = 'YOUR_NAME'
   and table_name = 'CANDYHIST_PART';



----------- Dropping a List partition -----------------
-- Dropping a List Partition
-- Two choices
---- Drop partition as well as data!
alter table candyhist_part
  drop partition p_def;

---- Merge two partitions together (date moved)
alter table candyhist_part
  merge partitions p_2004, p_2005
    into partition p_200505;


----------------- Range Partitions --------------------
------------ What is a Range partition ----------------
-- Creates partitions using a range of  values using one or more columns
-- Overview Example: SURVEY_DATE
-- Can create partitions with non-existent values
-- MAXVALUE keyword -> unhandled values stored in default partition
-- Each partition can be in a separate tablespace (TABLESPACE keyword)
-- WHERE Clause contains partitions columns -> Partition Pruning

----------- Creating a Range partition ----------------
-- example
-- basic
create table candy_part
(
  respondent_id   number,
  respondent_name varchar2(100),
  survey_year     number,
  survey_date     date
)
-- partition syntax
  partition by range
  (
   survey_date
    )
(
  partition p_2004 values less than (date '2005-01-01'),
  partition p_2005 values less than (date '2006-01-01'),
  partition p_2006 values less than (date '2007-01-01'),
  partition p_rest values less than (maxvalue)
);



------------ Adding a Range partition -----------------
-- Can add additional partitions at later date
---- Use ALTER TABLE statement's ADD PARTITION Clause
---- Adding p_2018 partition
alter table candyhist_part
  add partition p_2018 values less than (date '2019-01-01');
-- The statement is different if the maxvalue partition exists on the table
alter table candyhist_part
  split partition p_def at (date '2015-01-01')
    into (partition p_2014, partition p_def);



----------- Dropping a Range partition ----------------
-- Dropping a List Partition
-- Two choices
---- Drop partition as well as data!
alter table candyhist_part
  drop partition p_def;

---- Merge two partitions together (date moved)
alter table candyhist_part
  merge partitions p_2004, p_2005
    into partition p_old_data;