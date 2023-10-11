create database portfolio_projects;
select *
from portfolio_projects.dbo.coviddeaths
where continent is not null
order by 3,4

select *
from portfolio_projects.dbo.covidvaccinations
order by 3,4


---select data that we are going to be using

select location, date, total_cases, new_cases,total_deaths, population
from portfolio_projects.dbo.coviddeaths
order by 1,2

----looking at total cases vs total deaths 
select CONVERT(decimal, total_cases) as total_cases1
from portfolio_projects.dbo.coviddeaths
select CONVERT(decimal, total_deaths) as total_deaths1
from portfolio_projects.dbo.coviddeaths

select location, date, total_cases, total_deaths, convert(decimal,total_deaths)/CONVERT(decimal, total_cases)*100 as deathpercentage
from portfolio_projects.dbo.coviddeaths
where location like '%Pakistan%'
order by 1,2

---looking at total cases vs population

select location, date, total_cases, population, (total_cases/Cpopulation)*100 as deathpercentage
from portfolio_projects.dbo.coviddeaths
where location like '%Pakistan%'
order by 1,2

---looking at countries with highest infection rate comapred to population

select location, population, max(total_cases) as highestinfection, max(total_cases)/population * (100) as highestpercent
from portfolio_projects.dbo.coviddeaths
group by location, population
order by highestpercent desc

---looking for countries with highest death count population

select location, max(cast(total_deaths as int)) as totaldeathcount
from portfolio_projects.dbo.coviddeaths
where continent is not null
group by location
order by totaldeathcount desc

----breaking things down by continent

select location, max(cast(total_deaths as int)) as totaldeathcount
from portfolio_projects.dbo.coviddeaths
where continent is null
group by location
order by totaldeathcount desc


select continent, max(cast(total_deaths as int)) as totaldeathcount
from portfolio_projects.dbo.coviddeaths
where continent is not null
group by continent
order by totaldeathcount desc

--globalnumbers

select date, SUM(cast(new_cases as int)) as totalcases,
SUM(cast(new_deaths as int)) as totaldeaths
from portfolio_projects.dbo.coviddeaths
where continent is not null
group by date
order by 1,2 

--aggregated globalnumbers

select sum(new_cases) as totalcases, 
SUM(cast(new_deaths as int)) as totaldeaths
from portfolio_projects.dbo.coviddeaths
where continent is not null
order by 1,2

--covid vaccination

select *
from portfolio_projects.dbo.covidvaccinations

--looking at total population vs vaccinations
select *
from portfolio_projects.dbo.coviddeaths dea
Join portfolio_projects.dbo.covidvaccinations vac
on dea.location = vac.location
and dea.date = dea.date

select dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations
from portfolio_projects.dbo.coviddeaths dea
Join portfolio_projects.dbo.covidvaccinations vac
on dea.location = vac.location
and dea.date = dea.date
where dea.continent is not null
order by 1,2


select dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
sum(convert(decimal, vac.new_vaccinations)) OVER (PARTITION by dea.location) as total_vaccinations
from portfolio_projects.dbo.coviddeaths dea
Join portfolio_projects.dbo.covidvaccinations vac
on dea.location = vac.location
and dea.date = dea.date
where dea.continent is not null
order by 1,2

select location
from portfolio_projects.dbo.coviddeaths

--USING CTE 

with popvsvac (continent, location,date, population, new_vaccinations, total_vaccinations)
as
(
select dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
sum(convert(decimal, vac.new_vaccinations)) OVER (PARTITION by dea.location) as total_vaccinations
from portfolio_projects.dbo.coviddeaths dea
Join portfolio_projects.dbo.covidvaccinations vac
on dea.location = vac.location
and dea.date = dea.date
where dea.continent is not null
)
order by 1,2