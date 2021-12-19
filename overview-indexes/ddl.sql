-- Create the subset tables for respondents
create table resp_subset_10 as
select respondent_id
  from respondent_dim
 where respondent_id between 1 and 10;

create table resp_subset_100 as
select respondent_id
  from respondent_dim
 where respondent_id between 1 and 100;

create table resp_subset_1000 as
select respondent_id
  from respondent_dim
 where respondent_id between 1 and 1000;

-- Create indexes for the created tables
create index ix_respsubset10_respid on resp_subset_10(respondent_id);

create index ix_respsubset100_respid on resp_subset_100(respondent_id);

create index ix_respsubset1000_respid on resp_subset_1000(respondent_id);

-- Gather statistics for the created indexes
declare
  schema_owner constant varchar2(20 char) := 'YOUR_NAME';
begin
  dbms_stats.gather_table_stats(ownname => schema_owner,
                                tabname => 'RESP_SUBSET_10',
                                estimate_percent => dbms_stats.auto_sample_size);

  dbms_stats.gather_table_stats(ownname => schema_owner,
                                tabname => 'RESP_SUBSET_100',
                                estimate_percent => dbms_stats.auto_sample_size);

  dbms_stats.gather_table_stats(ownname => schema_owner,
                                tabname => 'RESP_SUBSET_100',
                                estimate_percent => dbms_stats.auto_sample_size);
end;

-- Create an index for respondent_id on the candybar_fact table
create index ix_cndfact_respid on candybar_fact(respondent_id);

-- Gather statistics for the newly created index
declare
  schema_owner constant varchar2(20 char) := 'YOUR_NAME';
begin
  dbms_stats.gather_table_stats(ownname => schema_owner,
                                tabname => 'CANDYBAR_FACT',
                                estimate_percent => dbms_stats.auto_sample_size);
end;
