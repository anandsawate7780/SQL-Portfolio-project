use project;
select * from data1
select * from data2

--number of row in our dataset.
select COUNT(*) as total_rows from data1
select COUNT(*) as total_rows from data2

--dataset for Andhra Pradesh and Bihar.
select * from data1 where state in ('Andhra Pradesh','Bihar')

--Total Population of india.
select sum(Population) as Total_Population from data2

-- Avg Growth of india.
select avg(growth) as Avg_Growth from data1;

--Avg Growth of india in %
select avg(growth)*100 as Avg_Growth from data1;

--Avg Growth of india in % by state.
select State, avg(growth)*100 as Avg_Growth from data1 group by State;

--Avg sex ratio of india .
select State,round(avg(sex_ratio),0) as Avg_sex_ratio from data1 group by State order by avg_sex_ratio desc;

--Avg literacy ratio of india .
select State,round(avg(literacy),0) as Avg_literacy_ratio from data1 
group by State having round(avg(literacy),0)>90 order by avg_literacy_ratio desc;

--top 3 state showing highest education rate.
select top 3 State, avg(growth)*100 as Avg_Growth from data1 group by State order by Avg_Growth desc;

--bottom 3 state showing lowest sex ratio.
select top 3 State,round(avg(sex_ratio),0) as Avg_sex_ratio from data1 group by State order by avg_sex_ratio asc;

--top and bottom 3 state in literacy state.
drop table if exists Top_states
create table Top_states
(state nvarchar(255),
Top_states float)

insert into Top_states
select  State,round(avg(literacy),0) as Avg_literacy_ratio from data1 
group by State order by avg_literacy_ratio desc;

select top 3 * from Top_states order by Top_states desc;

drop table if exists Bottom_states
create table Bottom_states
(state nvarchar(255),
Bottom_states float)

insert into Bottom_states
select  State,round(avg(literacy),0) as Avg_literacy_ratio from data1 
group by State order by avg_literacy_ratio desc;

-- Join two results using Union Operators.
select * from (
select top 3 * from Top_states order by Top_states desc) a
union

select * from (
 select top 3 * from Bottom_states order by Bottom_states asc) b;

 --state starting with latter a
 select distinct state from data1 where state like 'a%' or state like 'b%';

  --state starting with latter a and end with h
 select distinct state from data1 where state like 'a%' and state like '%h';

 --joining both tables
select a.district,a.state,a.sex_ratio/1000 as sex_ratio, b.population from data1 a inner join data2 b on a.district=b.District                     

-- find total number of males and females by state.
select d.state, sum(d.males) as Total_Males, sum(d.females) as Total_Females from
(select c.district,c.state , round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.Sex_Ratio)/(c.sex_ratio+1),0) females from 
(select a.district, a.state, a.sex_ratio/1000 as sex_ratio, b.population from data1 a inner join data2 b on a.district=b.district)c) d
group by d.state;


--total Literacy rate.
select  c.state,sum(literate_people) as Total_literate_people,sum(illiterate_people) as Total_illiterate_people from
(select d.district,d.state,round(d.literacy_ratio*d.population,0) as literate_people,round((1-d.literacy_ratio)*d.population,0) as illiterate_people from 
(select a.district, a.state, a.literacy/100 as literacy_ratio, b.population from data1 a inner join data2 b on a.district=b.district) d) c
group by c.state

--population in privious sensus.
select sum(m.privious_sensus_population)privious_sensus_population,sum(m.current_sensus_population)current_sensus_population from
(select e.state, sum(e.privious_sensus_population)  privious_sensus_population, sum(e.current_sensus_population) current_sensus_population from
(select d.district,d.state,round (d.population/(1+growth),0) privious_sensus_population,d.population current_sensus_population from 
(select a.district, a.state, a.growth, b.population from data1 a inner join data2 b on a.district=b.district) d)e
group by e.state)m


-- top 3 district from each state where highest literacy rate.
select a. * from
(select district,state,literacy, rank()over (partition by state order by literacy desc) rnk from data1)a
where a.rnk in (1,2,3) order by state;