-- Indexes in general

-- the Jump to a row, avoid full table scans when possible, increase join operations,
-- speed up count(*) aggregation, speed up order by, group by, useful with constraints

-- Caution, Oracle used an index only if the subsetting of the result is 15% of the total set, otherwise ignores indexes
-- Also inserts, updates and deletes are slower the more indexes the table has


------ B-Tree Indexes ------
-- The most general purpose index available
-- They shape like a tree where the root is the index and going down the leaves are the rowids


------ Bitmap Indexes ------
-- Stored as a series of bits (0 or 1) indicating row inclusion / exclusion
-- They are useful when the distinct column values << total number of rows
-- Frequently used in Data Warehouses
-- Example: Index the CANDYBAR_ID column in CANDYBAR_FACT (250 distinct values << 5 million)
-- For every unique value (candybar_id = 1, 2, ..., 250) the index has a series of 5 million 0 or 1 for every
-- row of the table, indicating if the candybar_id on the specific row is 1 = TRUE or 0 = FALSE
-- The space that Bitmap indexes take is vey big, so Oracle suggests the the distinct number of rows (and therefore
-- the number of different 0 and 1 series) are very few compared to the total number of rows


------ Function-Based Indexes ------
-- Function (e.g., UPPER()) forces index to be ignored
-- Function-Based Index defined with function applied e.g. UPPER(candybar_name)
-- Multi-column expressions: 100 * (taste_rating / overall_rating) and in order for Oracle to use that index
-- the WHERE clause must reference the exact function
-- e.g. WHERE 100 * (taste_rating / overall_rating) <= 10


------ Index-Organized Tables ------
-- Combines table and index into one object
-- Stored based on the primary key
-- In contrast of B-Tree indexes the store in each index all the row data, not only the rowid
-- Dimension Tables / Hierarchical Tables benefit from this category of indexes
-- Not frequently used in practice


------ Bitmap Join Indexes ------
-- Performs the join up-front
-- Inner joins betwwen tables
-- Must decide on column(s) to index
-- Can be very fast
-- e.g. respondent_dim.respondent_state joins upfront the series of 0 and 1 of responder_id and state_id
-- for state so when the WHERE clause has 'GR' as value then the series of responder id has the series of
-- 0 and 1 of responder_id combined with the series of 0 and 1 of respondent_state


------ Gathering Statistics ------
-- Statistics help the Optimized determine the optional query plan
-- After creating indexes -> gather statistics
-- Helps Oracle decide best way to run query
-- If no stats, no index will be used
-- Should see significant improvement
-- Use DBMS_STATS package instead
-- Avoid older ANALYZE command
-- From 10g version it is not always necessary -> Oracle gathers automatic statistics when the table changes


------ Indexes and Partitions ------
-- Partitions ~ Individual Tables
-- Indexes within each individual partition (Local Partitioned Indexes)
-- Indexes across all partitions (Global Non-Partitioned Indexes)
-- Indexes using different partition scheme (Global Partitioned Indexes)


------ Example ------
-- First crate the tables resp_subset_10, resp_subset_100, resp_subset_1000
-- Then merge without any indexes
-- resp_subset_10
select cf.*
  from candybar_fact cf inner join resp_subset_10 r on cf.respondent_id = r.respondent_id; -- 600 ms

-- resp_subset_100
select cf.*
  from candybar_fact cf inner join resp_subset_100 r on cf.respondent_id = r.respondent_id; -- 650 ms

-- resp_subset_1000
select cf.*
  from candybar_fact cf inner join resp_subset_1000 r on cf.respondent_id = r.respondent_id; -- 700 ms

-- Then create indexes on the subset tables and the respid for candybar_fact and gather statistics for the indexes

-- Execute the exact queries again
-- resp_subset_10
select cf.*
  from candybar_fact cf inner join resp_subset_10 r on cf.respondent_id = r.respondent_id; -- 100 ms

-- resp_subset_100
select cf.*
  from candybar_fact cf inner join resp_subset_100 r on cf.respondent_id = r.respondent_id; -- 129 ms

-- resp_subset_1000
select cf.*
  from candybar_fact cf inner join resp_subset_1000 r on cf.respondent_id = r.respondent_id; -- 146 ms





