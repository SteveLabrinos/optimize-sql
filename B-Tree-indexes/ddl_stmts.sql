-- There are already B-Tree indexes for the crated dim and fact tables
-- that were created for the primary keys constraints
-- Therefore the only alteration is about candybar_fact table that used parallel for the index
alter index PK_CANDYBAR_FACT parallel;