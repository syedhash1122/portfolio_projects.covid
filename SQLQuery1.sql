select dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
sum(convert(decimal, vac.new_vaccinations)) OVER (PARTITION by dea.location) as total_vaccinations
from portfolio_projects.dbo.coviddeaths dea
Join portfolio_projects.dbo.covidvaccinations vac
on dea.location = vac.location
and dea.date = dea.date
where dea.continent is not null
order by 1,2

--USING CTE
with popvsvac (continent, location, date, population, new_vaccinations, total_vaccinations)
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
select *, (total_vaccinations/population) * 100
from popvsvac
order by 1,2

--temp table
drop table if exists
Create table #percentpopulation
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccionations numeric,
total_vaccinations numeric
)
insert into #percentpopulation
select dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
sum(convert(decimal, vac.new_vaccinations)) OVER (PARTITION by dea.location) as total_vaccinations
from portfolio_projects.dbo.coviddeaths dea
Join portfolio_projects.dbo.covidvaccinations vac
on dea.location = vac.location
and dea.date = dea.date
where dea.continent is not null
--order by 1,2

select *, total_vaccinations/population * (100) as vacpoppercentage
from #percentpopulation

--creating view for later visualizations
create view percentpopulation 
as
select dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
sum(convert(decimal, vac.new_vaccinations)) OVER (PARTITION by dea.location) as total_vaccinations
from portfolio_projects.dbo.coviddeaths dea
Join portfolio_projects.dbo.covidvaccinations vac
on dea.location = vac.location
and dea.date = dea.date
where dea.continent is not null