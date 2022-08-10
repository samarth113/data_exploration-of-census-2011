select *
from portfolio.dataset1;

 select * from portfolio.dataset2;


-- dataset for ballia district

select *
from portfolio.dataset1
where state = "Uttar Pradesh" and District="Ballia";

-- total population of India
 select sum(Population) as Total_Population from portfolio.dataset2;

-- average growth of population for whole India
select avg(growth) as avg_growth from portfolio.dataset1;

-- avgerage growth of Uttar Pradesh
select state,avg(growth) as avg_growth from portfolio.dataset1 where State = "Uttar Pradesh";

-- avgerage growth of each state
select state, round(avg(growth),2) as avg_growth from portfolio.dataset1
 group by state;

-- average sex ratio for whole India
select avg(Sex_Ratio) as avg_sex_ratio from portfolio.dataset1;

-- average sex ratio for each state by avg_sex_ratio in Descending Order
select state, round(avg(Sex_Ratio) ,2) as avg_sex_ratio from portfolio.dataset1
 group by state
 order by avg_sex_ratio DESC;
 
 -- average literacy rate for whole India
select avg(Literacy) as avg_literacy_rate from portfolio.dataset1;

-- average literacy rate for each state
 select state, round(avg(Literacy) ,0) as avg_literacy_rate from portfolio.dataset1 
 group by state
  order by avg_literacy_rate  DESC;
  
-- average literacy rate for each state having average literacy rate > 80
 select state, round(avg(Literacy) ,0) as avg_literacy_rate from portfolio.dataset1 
group by state
 HAVING avg_literacy_rate > 80
 order by avg_literacy_rate desc;

-- Top 3 state by avg_grwoth_rate
select  state, round(avg(growth),2) as avg_growth from portfolio.dataset1
 group by state
 order by avg_growth desc
 limit 3;
 
-- Bottom 3 state by avg_grwoth_rate 
select  state, round(avg(growth),2) as avg_growth from portfolio.dataset1
 group by state
 order by avg_growth asc
 limit 3;

-- Bottom 3 state by average sex ratio
select state, round(avg(Sex_Ratio) ,2) as avg_sex_ratio from portfolio.dataset1
 group by state
 order by avg_sex_ratio asc
 limit 3;
 
 -- top 3 and bottom 3 states by literacy rate in single table by creating temporary table 

drop table if exists top_states;

create table top_states(states text, avg_literacy_rate float);

insert into top_states 
 select state, round(avg(Literacy) ,0) as avg_literacy_rate from portfolio.dataset1 
 group by state
 order by avg_literacy_rate  DESC
 limit 3;

select * from top_states;
-- -----------------------------------------------------------

drop table if exists bottom_states;
create table bottom_states(states text, avg_literacy_rate float);

insert into bottom_states 
 select state, round(avg(Literacy) ,0) as avg_literacy_rate from portfolio.dataset1 
 group by state
 order by avg_literacy_rate  asc
 limit 3;

select * from bottom_states;

-- COMBINING THE RESULT INTO SINGLE TABLE
select * from top_states
UNION
select * from bottom_states;

-- USE of LIKE statement

select State from portfolio.dataset1 where state like "%a";
select State from portfolio.dataset1 where state like "a%";
select State from portfolio.dataset1 where state like "a%" and state like "%m";


-- JOIN both table

-- select t1.district, t1.state,t1.sex_ratio, t1.literacy,t2.population
-- from portfolio.dataset1 t1 join portfolio.dataset2 t2 on t1.district = t2.district;
 
-- females/males = sex_ratio 
-- female + males = Population
-- males = Population/(1+sex_ratio)
-- females = population*(1-1/(1+sex_ratio))

select c.district,c.state,c.population,
(c.population)/(c.sex_ratio+1)  as Males,
(c.population*c.sex_ratio)/(c.sex_ratio+1)  as Females
from(select t1.district, t1.state,t1.sex_ratio/1000 as sex_ratio,t2.population from 
      portfolio.dataset1 t1 join portfolio.dataset2 t2 on t1.district = t2.district) c;

-- males and female data by states
select t3.state, sum(t3.Males) as total_males, sum(t3.Females) as total_females from 
(select c.district,c.state,population,(c.population)/(c.sex_ratio+1)  as Males,
(c.population*c.sex_ratio)/(c.sex_ratio+1)  as Females from
(select t1.district, t1.state,t1.sex_ratio/1000 as sex_ratio,t2.population from 
      portfolio.dataset1 t1 join portfolio.dataset2 t2 on t1.district = t2.district) c) t3 
group by t3.state;













































































































