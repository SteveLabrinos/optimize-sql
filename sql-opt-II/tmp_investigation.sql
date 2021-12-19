--Correlated Sub query
select count(distinct a.respondent_id) as dist_cnt
  from candybar_fact a
 where respondent_id = (select b.respondent_id
                          from respondent_dim b
                         where b.respondent_id = a.respondent_id
                           and b.respondent_gender = 'M');


-- re-write
-- because the inner query is really small compared to the outer (2.5k inner VS 5m outer) we prefer in operator
select count(distinct a.respondent_id) as dist_cnt
  from candybar_fact a
 where respondent_id in (select b.respondent_id
                           from respondent_dim b
                          where b.respondent_gender = 'M');

select count(distinct a.respondent_id) as dist_cnt
  from candybar_fact a
 where exists(select 1
                from respondent_dim b
               where b.respondent_id = a.respondent_id
                 and b.respondent_gender = 'M');

select count(distinct a.respondent_id) as dist_cnt
  from candybar_fact a
         inner join respondent_dim cd on cd.respondent_id = a.respondent_id
 where cd.respondent_gender = 'M';


-- Using multiple combined OR for more than 2 column conditions
select count(*) as tot_records
  from candybar_fact
 where (respondent_id = 4 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 6 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 8 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 11 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 12 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 17 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 18 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 19 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 21 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 63 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 82 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 87 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 88 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 96 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 97 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 108 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 117 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 119 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 125 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 134 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 137 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 142 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 150 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 152 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 170 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 181 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 183 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 204 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 208 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 218 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 224 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 256 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 259 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 264 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 283 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 292 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 294 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 297 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 305 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 309 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 310 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 321 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 331 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 332 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 359 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 362 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 371 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 377 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 380 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 396 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 427 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 429 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 444 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 446 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 455 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 461 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 463 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 465 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 469 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 474 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 485 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 490 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 520 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 523 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 537 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 545 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 550 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 572 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 591 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 596 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 607 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 609 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 612 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 615 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 616 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 621 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 622 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 628 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 631 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 641 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 643 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 646 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 652 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 656 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 664 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 695 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 697 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 716 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 717 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 721 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 736 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 744 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 761 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 763 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 773 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 779 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 780 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 781 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 787 and candybar_id = 70 and survey_date = date '2013-03-12')
    or (respondent_id = 792 and candybar_id = 70 and survey_date = date '2013-03-12');

select count(*) as tot_records
  from candybar_fact
 where (respondent_id, candybar_id, survey_date) in (
                                                     (4, 70, date '2013-03-12'),
                                                     (6, 70, date '2013-03-12'),
                                                     (8, 70, date '2013-03-12'),
                                                     (11, 70, date '2013-03-12'),
                                                     (12, 70, date '2013-03-12'),
                                                     (17, 70, date '2013-03-12'),
                                                     (18, 70, date '2013-03-12'),
                                                     (19, 70, date '2013-03-12'),
                                                     (21, 70, date '2013-03-12'),
                                                     (63, 70, date '2013-03-12'),
                                                     (82, 70, date '2013-03-12'),
                                                     (87, 70, date '2013-03-12'),
                                                     (88, 70, date '2013-03-12'),
                                                     (96, 70, date '2013-03-12'),
                                                     (97, 70, date '2013-03-12'),
                                                     (108, 70, date '2013-03-12'),
                                                     (117, 70, date '2013-03-12'),
                                                     (119, 70, date '2013-03-12'),
                                                     (125, 70, date '2013-03-12'),
                                                     (134, 70, date '2013-03-12'),
                                                     (137, 70, date '2013-03-12'),
                                                     (142, 70, date '2013-03-12'),
                                                     (150, 70, date '2013-03-12'),
                                                     (152, 70, date '2013-03-12'),
                                                     (170, 70, date '2013-03-12'),
                                                     (181, 70, date '2013-03-12'),
                                                     (183, 70, date '2013-03-12'),
                                                     (204, 70, date '2013-03-12'),
                                                     (208, 70, date '2013-03-12'),
                                                     (218, 70, date '2013-03-12'),
                                                     (224, 70, date '2013-03-12'),
                                                     (256, 70, date '2013-03-12'),
                                                     (259, 70, date '2013-03-12'),
                                                     (264, 70, date '2013-03-12'),
                                                     (283, 70, date '2013-03-12'),
                                                     (292, 70, date '2013-03-12'),
                                                     (294, 70, date '2013-03-12'),
                                                     (297, 70, date '2013-03-12'),
                                                     (305, 70, date '2013-03-12'),
                                                     (309, 70, date '2013-03-12'),
                                                     (310, 70, date '2013-03-12'),
                                                     (321, 70, date '2013-03-12'),
                                                     (331, 70, date '2013-03-12'),
                                                     (332, 70, date '2013-03-12'),
                                                     (359, 70, date '2013-03-12'),
                                                     (362, 70, date '2013-03-12'),
                                                     (371, 70, date '2013-03-12'),
                                                     (377, 70, date '2013-03-12'),
                                                     (380, 70, date '2013-03-12'),
                                                     (396, 70, date '2013-03-12'),
                                                     (427, 70, date '2013-03-12'),
                                                     (429, 70, date '2013-03-12'),
                                                     (444, 70, date '2013-03-12'),
                                                     (446, 70, date '2013-03-12'),
                                                     (455, 70, date '2013-03-12'),
                                                     (461, 70, date '2013-03-12'),
                                                     (463, 70, date '2013-03-12'),
                                                     (465, 70, date '2013-03-12'),
                                                     (469, 70, date '2013-03-12'),
                                                     (474, 70, date '2013-03-12'),
                                                     (485, 70, date '2013-03-12'),
                                                     (490, 70, date '2013-03-12'),
                                                     (520, 70, date '2013-03-12'),
                                                     (523, 70, date '2013-03-12'),
                                                     (537, 70, date '2013-03-12'),
                                                     (545, 70, date '2013-03-12'),
                                                     (550, 70, date '2013-03-12'),
                                                     (572, 70, date '2013-03-12'),
                                                     (591, 70, date '2013-03-12'),
                                                     (596, 70, date '2013-03-12'),
                                                     (607, 70, date '2013-03-12'),
                                                     (609, 70, date '2013-03-12'),
                                                     (612, 70, date '2013-03-12'),
                                                     (615, 70, date '2013-03-12'),
                                                     (616, 70, date '2013-03-12'),
                                                     (621, 70, date '2013-03-12'),
                                                     (622, 70, date '2013-03-12'),
                                                     (628, 70, date '2013-03-12'),
                                                     (631, 70, date '2013-03-12'),
                                                     (641, 70, date '2013-03-12'),
                                                     (643, 70, date '2013-03-12'),
                                                     (646, 70, date '2013-03-12'),
                                                     (652, 70, date '2013-03-12'),
                                                     (656, 70, date '2013-03-12'),
                                                     (664, 70, date '2013-03-12'),
                                                     (695, 70, date '2013-03-12'),
                                                     (697, 70, date '2013-03-12'),
                                                     (716, 70, date '2013-03-12'),
                                                     (717, 70, date '2013-03-12'),
                                                     (721, 70, date '2013-03-12'),
                                                     (736, 70, date '2013-03-12'),
                                                     (744, 70, date '2013-03-12'),
                                                     (761, 70, date '2013-03-12'),
                                                     (763, 70, date '2013-03-12'),
                                                     (773, 70, date '2013-03-12'),
                                                     (779, 70, date '2013-03-12'),
                                                     (780, 70, date '2013-03-12'),
                                                     (781, 70, date '2013-03-12'),
                                                     (787, 70, date '2013-03-12'),
                                                     (792, 70, date '2013-03-12')
   );


-- Multiple Statements with little changes
select distinct survey_year, respondent_id
  from date_dim
         inner join candybar_fact cf on date_dim.survey_date = cf.survey_date
 where respondent_id in (select respondent_id
                           from respondent_dim
                          where respondent_gender = 'M')
   and survey_year = 2013
 union all
select distinct survey_year, respondent_id
  from date_dim
         inner join candybar_fact cf on date_dim.survey_date = cf.survey_date
 where respondent_id in (select respondent_id
                           from respondent_dim
                          where respondent_gender = 'M')
   and survey_year = 2012
 union all
select distinct survey_year, respondent_id
  from date_dim
         inner join candybar_fact cf on date_dim.survey_date = cf.survey_date
 where respondent_id in (select respondent_id
                           from respondent_dim
                          where respondent_gender = 'M')
   and survey_year = 2011;

-- Refactor with WITH clause (Subquery Factoring) - only runs once
  with vw_ml_resp as (select respondent_id
                        from respondent_dim
                       where respondent_gender = 'M')
select distinct survey_year, respondent_id
  from date_dim
         inner join candybar_fact cf on date_dim.survey_date = cf.survey_date
 where respondent_id in (select respondent_id
                           from vw_ml_resp)
   and survey_year = 2013
 union all
select distinct survey_year, respondent_id
  from date_dim
         inner join candybar_fact cf on date_dim.survey_date = cf.survey_date
 where respondent_id in (select respondent_id
                           from vw_ml_resp)
   and survey_year = 2012
 union all
select distinct survey_year, respondent_id
  from date_dim
         inner join candybar_fact cf on date_dim.survey_date = cf.survey_date
 where respondent_id in (select respondent_id
                           from vw_ml_resp)
   and survey_year = 2011;


-- Refactor with WITH clause (Subquery Factoring) - only runs once
  with vw_ml_resp as (select respondent_id
                        from respondent_dim
                       where respondent_gender = 'M')
select distinct survey_year, respondent_id
  from date_dim
         inner join candybar_fact cf on date_dim.survey_date = cf.survey_date
 where respondent_id in (select respondent_id
                           from vw_ml_resp)
   and survey_year between 2011 and 2013;

-- The Append Hint for INSERT
-- Best on tables with a lot of DELETES
-- insert /*+APPEND*/...


-- Order of tables with tables that contain few rows coming first
-- This is especially true when the join clauses of the tables don't have indexes on them
select cf.*
  from candybar_fact cf inner join respondent_dim rd on rd.respondent_id = cf.respondent_id;

-- faster when placing  the 2k rows table first
select cf.*
  from respondent_dim rd inner join candybar_fact cf on rd.respondent_id = cf.respondent_id;




