-------------------------------------------------------
------------- Additional Index Types ------------------
-------------------------------------------------------

------------- Function-Based Indexes ------------------
-- Function on Indexed Column -> Index Ignored
-- Index on Function/Expression -> Index considered
-- Example: WHERE UPPER(respondent_name) = 'SAMUEL BARSIOLA'
-- CREATE [BITMAP] INDEX Syntax is still the same
-- but the column is replaced by the function/expression involving column(s)

select *
  from respondent_dim
 where upper(respondent_name) = 'SAMUEL BARSIOLA';

-- SELECT (select)		20	9.0	cpu_cost = 842200, io_cost = 9
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: RESPONDENT_DIM;	20	9.0	cpu_cost = 842200, io_cost = 9

-- repeat the example with a single index (B-Tree) on respondent_name
-- SELECT (select)		20	9.0	cpu_cost = 842200, io_cost = 9
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: RESPONDENT_DIM;	20	9.0	cpu_cost = 842200, io_cost = 9

-- repeat the example with a function-based index created for upper(respondent_name)
-- ACCESS (TABLE ACCESS BY INDEX ROWID BATCHED)	 table: RESPONDENT_DIM;	20	8.0	cpu_cost = 69023, io_cost = 8
-- INDEX_SCAN (INDEX RANGE SCAN)	 index: IX_RESPDIM_UPPERRESPNAME;	8	1.0	cpu_cost = 9571, io_cost = 1

-- select the number of cases where the taste rating is much lower than the overall rating
select count(*) as tot
  from candybar_fact
 where 100 * (taste_rating / overall_rating) <= 10;

-- SORT (SORT AGGREGATE)		1		cpu_cost = null, io_cost = null
-- INDEX_SCAN (INDEX RANGE SCAN)	 index: IX_CNDFACT_TROAR;	250000	90.0	cpu_cost = 9640930, io_cost = 90


--------------- Bitmap Join Indexes -------------------
-- Pre-Joins tables -> Reduces SQL runtime
-- Usually involves a Fact and Dimension table(s)
-- One or more additional columns used for subsetting
-- Dimension table needs primary key/unique constraint

-- example of getting average rating for all respondents that are from WA, CT states
select cf.respondent_id, avg(cf.overall_rating) as avg_oar
  from candybar_fact cf
         inner join respondent_dim rd on cf.respondent_id = rd.respondent_id
 where rd.respondent_state in ('CT', 'WA')
 group by cf.respondent_id
 order by cf.respondent_id;

-- 657 ms to execute
-- GROUP_BY (SORT GROUP BY)		250	7508.0	cpu_cost = 2628750460, io_cost = 7442
-- HASH_JOIN (hash join)		625000	7494.0	cpu_cost = 2046881600, io_cost = 7442
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: RESPONDENT_DIM;	250	9.0	cpu_cost = 853150, io_cost = 9
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: CANDYBAR_FACT;	5000000	7472.0	cpu_cost = 1545390949, io_cost = 7433

-- repeat the query after creating a Bimap Join index
-- 163 ms
-- GROUP_BY (SORT GROUP BY)		2000	7506.0	cpu_cost = 2628068902, io_cost = 7440
-- HASH_JOIN (hash join)		625000	7492.0	cpu_cost = 2046200042, io_cost = 7440
-- UNKNOWN (INLIST ITERATOR)				cpu_cost = null, io_cost = null
-- ACCESS (TABLE ACCESS BY INDEX ROWID BATCHED)	 table: RESPONDENT_DIM;	250	7.0	cpu_cost = 171593, io_cost = 7
-- INDEX_SCAN (INDEX RANGE SCAN)	 index: IX_RESPDIM_RESPSTATE;	250	2.0	cpu_cost = 78486, io_cost = 2
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: CANDYBAR_FACT;	5000000	7472.0	cpu_cost = 1545390949, io_cost = 7433


------------- Index-Organizes Tables ------------------
-- Normally, index stored separately from the table
-- Normally, index stores ROWIDs for the table
-- Index-Organized Tables stores data in a B-Tree
-- Index-Organized Table is its own index
-- Index-Organized Table must have a primary key constraint
-- Data access faster since table and index are the same enitity
-- Index-Organized Tables -> space reduction
-- Remember: Thinner tables better
-- INCLUDING column_name OVERFLOW to separate out less used columns
-- No difference in SQL query, only in the create table

-- Get the average overall rating for state CT
select rdi.respondent_state, avg(cf.overall_rating) as avg_oar
  from candybar_fact cf
         inner join respondent_dim_iot rdi on cf.respondent_id = rdi.respondent_id
 where rdi.respondent_state = 'CT'
 group by rdi.respondent_state;
-- 382 ms
-- SORT (SORT GROUP BY NOSORT)		1	2.0	cpu_cost = 15493, io_cost = 2
-- NESTED_LOOPS (nested loops)		1	2.0	cpu_cost = 15493, io_cost = 2
-- NESTED_LOOPS (nested loops)		2500	2.0	cpu_cost = 15493, io_cost = 2
-- FULL_INDEX_SCAN (INDEX FULL SCAN)	 index: PK_RESPONDENT_DIM_IOT;	1	0.0	cpu_cost = 200, io_cost = 0
-- INDEX_SCAN (INDEX RANGE SCAN)	 index: IX_CNDFACT_RESPID;	2500	2.0	cpu_cost = 15293, io_cost = 2
-- INDEX_SCAN (TABLE ACCESS BY INDEX ROWID)	 table: CANDYBAR_FACT;	1	2.0	cpu_cost = 15293, io_cost = 2


