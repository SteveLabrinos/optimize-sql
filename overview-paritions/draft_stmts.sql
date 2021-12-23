-------------------------------------------------------
------------- Overview of Partitions ------------------
-------------------------------------------------------

--------------- What is a partition -------------------
-- Smaller Tables -> Faster query execution
-- Break apart large table into several smaller tables
-- Partitions similar to small tables concept
-- When used, called Partitions Pruning
-- Partitioning based on one or more columns (e.g. SURVEY_YEAR)
-- Handled automatically by Oracle
-- Each partition can be places in a separate tablespace
-- Can create partitions ahead of time
-- Partitions can also have sub-partitions


------------- Varieties of partitions -----------------
-- Simple Partitions: Range, List and Hash
---- Range (e.g. SURVEY_DATE, etc)
---- List (e.g. SURVEY_YEAR, LIKELIHOOD_PURCHASE, RESPONDENT_ID, etc)
-- Composite Partitions: Range-List, List-List etc
---- Range-List (e.g. SURVEY_DATE/RESPONDENT_GENDER, etc)
---- List-List (e.g. LIKELIHOOD_PURCHASE/RESPONDENT_GENDER, etc)


--------------- Partition-Wise Joins ------------------
-- Oracle can execute queries in parallel based on partitioning scheme
-- Table same partitions scheme -> Full partition-wise joins
-- Tables not same partitions scheme -> Partial partition-wise joins


----------- Partition/Index Interaction ---------------
-- There is an interaction between partitions and indexes
-- Partitions -> Individual Tables
-- Index within each individual partition (Local Partitioned Indexes)
-- Index across all partitions (Global Non-Partitioned Indexes)
-- Indexes with independent partitions (Global Partitions Indexes)


--------------------- Examples ------------------------
-- After the creation of the partitioned table by survey_year
-- an average overall rating for a specific gender and year
-- in the old candybar_historical_data takes about 10 sec to complete
-- Executing the exact statement in the partitioned table with no indexes set
select respondent_gender, avg(overall_rating) as avg_oar
  from candyhist_part
 where survey_year = 2004
 group by respondent_gender;
-- The query completed in 1,5 sec
-- The speed is gained only by the partitioning of the tables

