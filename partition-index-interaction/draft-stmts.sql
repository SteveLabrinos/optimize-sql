-------------------------------------------------------
---------- Partitions/Indexes Interaction -------------
-------------------------------------------------------

----------- Global Non-Partitioned Indexes ------------
-- These are the standard indexes created and it spans on the table regardless partitions
-- example partitioned table
create table candy_part
(
  respondent_id       number,
  respondent_name     varchar2(100),
  survey_year         number,
  likelihood_purchase number,
  survey_date         date
)
  partition by list
(
  survey_year
)
(
  partition p_456 values (2004, 2005, 2006),
  partition p_789 values (2007, 2008, 2009),
  partition p_def values (default)
);

-- the standard Global Non-Partitioned Index
create index gnix_candypart_likpurc on candy_part(likelihood_purchase);



-------------- Local Partitioned Indexes --------------
-- This kind of index depends on the partition of the table
create index lpix_candypart_likpurc on candy_part(likelihood_purchase) local;



-------- Changed in Partitions Affect Indexes ---------
-- What's the Effect on an index when a partition changes
-- Based on the previous table we create a new partition on the default
alter table candy_part
  split partition p_def values (2010, 2011, 2012)
    into (partition p_012, partition p_def);
-- now the local part of the index that was used on the default partition p_def
-- is unusable as shown in all_int_partitions view
-- Also the local index for the new partition p_012 is unusable

-- Repairing Unusable Local Partitioned Indexes
alter index lpix_candypart_likpurc rebuild partition p_def;
alter index lpix_candypart_likpurc rebuild partition p_012;
