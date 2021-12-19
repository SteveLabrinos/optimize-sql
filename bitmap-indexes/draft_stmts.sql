-------------------------------------------------------
----------------- Bitmap Indexes ----------------------
-------------------------------------------------------

------------- What is a Bitmap Index ------------------
-- When the cardinality is low
-- Can index one, two or more columns: simple or composite


----------- When to use a Bitmap Index ----------------
-- Used often in Data Warehouses
-- Ad-Hoc queries (WHERE Clause with ANDs/ORs)
-- Simple Bitmap Indexes are preferred to Composite Bitmap Indexes
-- Degree of Cardinality should be very low (about 1% of total rows)
-- Don't use on unique columns (Use B-Tree instead)
-- NULLs included in Bitmap Index (not in B-Tree)
-- Uses less space than corresponding B-Tree Index


------------- Creating a Bitmap Index -----------------
-- The syntax is the same as the B-Tree index with the difference than you specify
-- that the index is Bitmap after the CREATE keyword

-- CREATE INDEX syntax (by default the index is B-Tree). create_index ::=
---- CREATE -> BITMAP -> INDEX -> [schema.]index_name ->
---- ON -> ([cluster_index_clause] | table_index_clause | [bitmap_join_index_clause]) -> [UNUSABLE] ->;
-- table_index_clause ::=
---- [schema.] -> table -> [t_alias] -> ( ->index_expr{col_name} -> [(ASC | DESC), ] -> ) -> index_properties

-- Then crate a Bitmap Index on the candybar_fact on the candybar_id column (250 distinct values on 5 million rows)



------------ Dropping a Bitmap Index ------------------
-- DROP INDEX index_name;


------------ Is the Index Being Used ------------------
select avg(overall_rating) as avg_or
  from candybar_fact
 where candybar_id = 123;

-- In the last execution the total cost in the explain plan was 7433
-- Using the bitmap index (low cardinality) the new plan has a cost of 3005

-- SELECT (select)		1	3006.0	cpu_cost = 29504303, io_cost = 3005
-- SORT (SORT AGGREGATE)		1		cpu_cost = null, io_cost = null
-- ACCESS (TABLE ACCESS BY INDEX ROWID BATCHED)	 table: CANDYBAR_FACT;	20000	3006.0	cpu_cost = 29504303, io_cost = 3005
-- UNKNOWN (BITMAP CONVERSION TO ROWIDS)				cpu_cost = null, io_cost = null
-- UNKNOWN (BITMAP INDEX SINGLE VALUE)				cpu_cost = null, io_cost = null


-- Example of query without any Bitmap Index
select avg(cf.overall_rating) as avg_or
  from candybar_fact cf inner join respondent_dim rd on cf.respondent_id = rd.respondent_id
where cf.candybar_id = 7 and rd.respondent_gender = 'F';
-- EXPLAIN PLAN WITH NO BITMAP INDEXES
-- SELECT (select)		1	7475.0	cpu_cost = 1300966800, io_cost = 7442
-- SORT (SORT AGGREGATE)		1		cpu_cost = null, io_cost = null
-- HASH_JOIN (hash join)		6430	7475.0	cpu_cost = 1300966800, io_cost = 7442
-- NESTED_LOOPS (nested loops)		6430	7475.0	cpu_cost = 1300966800, io_cost = 7442
-- NESTED_LOOPS (nested loops)				cpu_cost = null, io_cost = null
-- UNKNOWN (STATISTICS COLLECTOR)				cpu_cost = null, io_cost = null
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: RESPONDENT_DIM;	643	9.0	cpu_cost = 879400, io_cost = 9
-- INDEX_SCAN (INDEX RANGE SCAN)	 index: PK_CANDYBAR_FACT;			cpu_cost = null, io_cost = null
-- INDEX_SCAN (TABLE ACCESS BY INDEX ROWID)	 table: CANDYBAR_FACT;	10	7466.0	cpu_cost = 1297390949, io_cost = 7433
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: CANDYBAR_FACT;	20000	7466.0	cpu_cost = 1297390949, io_cost = 7433

-- The same example using two Bitmap Indexes (candybar_id, and responder_gender)
select avg(cf.overall_rating) as avg_or
  from candybar_fact cf inner join respondent_dim rd on cf.respondent_id = rd.respondent_id
where cf.candybar_id = 7 and rd.respondent_gender = 'F';
-- EXPLAIN PLAN WITH TWO BITMAP INDEXES (1 IS USED)
-- 60% faster results --
-- SELECT (select)		1	3012.0	cpu_cost = 34227286, io_cost = 3011
-- SORT (SORT AGGREGATE)		1		cpu_cost = null, io_cost = null
-- HASH_JOIN (hash join)		6430	3012.0	cpu_cost = 34227286, io_cost = 3011
-- NESTED_LOOPS (nested loops)		6430	3012.0	cpu_cost = 34227286, io_cost = 3011
-- NESTED_LOOPS (nested loops)				cpu_cost = null, io_cost = null
-- UNKNOWN (STATISTICS COLLECTOR)				cpu_cost = null, io_cost = null
-- ACCESS (VIEW)		643	6.0	cpu_cost = 2026534, io_cost = 6
-- HASH_JOIN (hash join)				cpu_cost = null, io_cost = null
-- UNKNOWN (BITMAP CONVERSION TO ROWIDS)		643	1.0	cpu_cost = 7521, io_cost = 1
-- UNKNOWN (BITMAP INDEX SINGLE VALUE)				cpu_cost = null, io_cost = null
-- FULL_INDEX_SCAN (INDEX FAST FULL SCAN)	 index: PK_RESPONDENT_DIM;	643	6.0	cpu_cost = 544509, io_cost = 6
-- INDEX_SCAN (INDEX RANGE SCAN)	 index: PK_CANDYBAR_FACT;		9.0	cpu_cost = 66693, io_cost = 9
-- INDEX_SCAN (TABLE ACCESS BY INDEX ROWID)	 table: CANDYBAR_FACT;	10	3006.0	cpu_cost = 29504303, io_cost = 3005
-- ACCESS (TABLE ACCESS BY INDEX ROWID BATCHED)	 table: CANDYBAR_FACT;	20000	3006.0	cpu_cost = 29504303, io_cost = 3005

