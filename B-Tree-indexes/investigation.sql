-------------------------------------------------------
----------------- B-Tree Indexes ----------------------
-------------------------------------------------------

------------- What is a B-Tree Index ------------------
-- They are the most common index used in all RDBMS
-- They represent a tree where the root is the index and the leaves are the rowids
-- Can index one, tow or more columns: simple or composite indexes


------------ When to use a B-Tree Index ---------------
-- Indexes <- -> WHERE Clause
-- Gather and Inspect WHERE Clauses to determine what columns may need an index
-- e.g. WHERE likelihood_purchase in (8, 9, 10) may be an indicator to use an index on that column
-- PRIMARY KEY
---- Index created
---- Prevents accidental data duplication
---- Index <- -> Joins
-- Composite Indexes
---- Order of columns can be important
---- Index (A, B, C) -> (A) and (A, B)
---- Index (A, B, C) -> Oracle may use (B, C) and (C)
---- Go for coverage to determine the order of the columns in composite indexes
---- columns that always presented in WHERE Clauses may need to take lead in composite indexes
-- Indexes are used in WHERE Clauses when the equality is tested. Not equals, not in and not exists don't use indexes


-------------- Creating a B-Tree Index -----------------
-- CREATE INDEX syntax (by default the index is B-Tree). create_index ::=
---- CREATE -> [(UNIQUE | BITMAP)] -> INDEX -> [schema.]index_name ->
---- ON -> ([cluster_index_clause] | table_index_clause | [bitmap_join_index_clause]) -> [UNUSABLE] ->;
-- table_index_clause ::=
---- [schema.] -> table -> [t_alias] -> ( ->index_expr{col_name} -> [(ASC | DESC), ] -> ) -> index_properties


------------- Listing the Indexes on a Table -----------
-- Usually you forget the names of the indexes created for a table
-- ALL_TABLES
---- Lists all the tables accessible to you
select owner, table_name, tablespace_name
  from all_tables
 where owner = 'YOUR_NAME'
 order by table_name;

-- ALL_TAB_COLUMNS
---- Lists all the columns in a table
select table_name, column_name, data_type, data_length, nullable
  from all_tab_columns
 where owner = 'YOUR_NAME'
   and table_name = 'CANDYBAR_FACT'
 order by column_id;

-- ALL_INDEXES
---- Lists all the indexes accessible to you
select owner, index_type, index_name, table_name, tablespace_name
  from all_indexes
 where owner = 'YOUR_NAME'
 order by index_name, table_owner, table_name;

-- ALL_IND_COLUMNS
---- Lists all the indexes accessible to you
select table_name, index_name, column_name
  from all_ind_columns
 where table_owner = 'YOUR_NAME'
 order by table_name, index_name, column_position;


----------------- Dropping a B-Tree Index --------------
-- DROP INDEX index_name
-- Cannot drop indexes that are pair with a primary key or unique constraint


------------------ Gathering Statistics ----------------
-- DBMS_STATS package
---- Several Available Procedures mainly for DBA purposes
---- The two important procedures are
------ GATHER_SCHEMA_STATS  - gathers stats on all the tables in a schema
------ GATHER_TABLE_STATS   - gathers stats on a specific table
---- *_TAB_STATISTICS/*_TAB_COL_STATISTICS/*_IND_STATISTICS


---------------- Is an Index Being Used? ---------------
-- AUTOTRACE and EXPLAIN PLAN
-- Need PLAN_TABLE - the dba can run (UTLXPLAN.SQL)
-- AUTOTRACE - executes the SQL code


select *
  from candybar_dim
         inner join candybar_fact cf on candybar_dim.candybar_id = cf.candybar_id;
-- Performs FULL SCAN because the FACT table doesn't have an index on candybar_id column

-- SELECT (select)		5000000	7493.0	cpu_cost = 2246116556, io_cost = 7436
-- HASH_JOIN (hash join)		5000000	7493.0	cpu_cost = 2246116556, io_cost = 7436
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: CANDYBAR_DIM;	250	3.0	cpu_cost = 88107, io_cost = 3
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: CANDYBAR_FACT;	5000000	7477.0	cpu_cost = 1745390949, io_cost = 7433

select avg(overall_rating) as avg_or
  from candybar_fact
 where candybar_id = 123;
-- Performs FULL SCAN because the FACT table doesn't have an index on candybar_id column

-- SELECT (select)		1	7466.0	cpu_cost = 1297390949, io_cost = 7433
-- SORT (SORT AGGREGATE)		1		cpu_cost = null, io_cost = null
-- SEQ_SCAN (TABLE ACCESS FULL)	 table: CANDYBAR_FACT;	20000	7466.0	cpu_cost = 1297390949, io_cost = 7433

select avg(overall_rating) as avg_or
  from candybar_fact
 where respondent_id = 1;
-- Performs an INDEX RANGE SCAN because of the IX_CNDFACT_RESPID index and the cost is way lower
-- SELECT (select)		1	84.0	cpu_cost = 1737481, io_cost = 84
-- SORT (SORT AGGREGATE)		1		cpu_cost = null, io_cost = null
-- ACCESS (TABLE ACCESS BY INDEX ROWID BATCHED)	 table: CANDYBAR_FACT;	2500	84.0	cpu_cost = 1737481, io_cost = 84
-- INDEX_SCAN (INDEX RANGE SCAN)	 index: IX_CNDFACT_RESPID;	2500	8.0	cpu_cost = 541772, io_cost = 8

