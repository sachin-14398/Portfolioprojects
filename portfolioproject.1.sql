select * from 
PortfolioProject..coviddeaths
where continent is not null 
--Total Cases vs Total Deaths

select location , date , total_cases , total_deaths , (total_deaths/total_cases)*100 as death_percentage
from PortfolioProject..coviddeaths
where location = 'india'
order by 1,2

 --Total Cases vs Total Population

Select location , date , total_cases , population , (total_cases/population)*100 as pop_got_covid
from PortfolioProject..coviddeaths
where location = 'india'
order by 1,2

--Countries with highest infection rate

select location , population ,date ,  MAX(total_cases) as Highestinfectioncount , MAX(total_cases/population)*100 as Percentpopinfected
from PortfolioProject..coviddeaths
where location = 'india'
group by location , population ,date
order by Percentpopinfected desc

--Countries with high death count

select continent , MAX(cast(total_deaths as int)) as Total_death_count
from PortfolioProject..coviddeaths
--where location = 'india'
where continent is not null 
group by continent
order by Total_death_count desc

--Global Numbers

select  sum(new_cases) as Total_cases , sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_percentage
from PortfolioProject..coviddeaths
where continent is not null
--group by date 
order by 1,2


--Looking at Total popuation vs Vaccinations

select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations , sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as peoplevaccinated 
from Portfolioproject..coviddeaths dea
join Portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--using cte

with popvsvac (continent , location , date , population , new_vaccinations , peoplevaccinated)
as
(select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations , sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as peoplevaccinated 
from Portfolioproject..coviddeaths dea
join Portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (peoplevaccinated/population)*100 as percentpeoplevaccinated
from popvsvac


--Temp Table
create table percentpeoplevaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
peoplevaccinated numeric
)
insert into percentpeoplevaccinated
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations , sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as peoplevaccinated 
from Portfolioproject..coviddeaths dea
join Portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

select *, (peoplevaccinated/population)*100 as percentpeoplevaccinated
from percentpeoplevaccinated




select location , date ,total_tests , total_vaccinations 
from PortfolioProject..covidvaccinations
where location = 'india' and total_tests > 0 and total_vaccinations != 'NULL'
order by 1,2


--Create view 
--drop view percentpeoplevaccinated
create view peoplevaccinatedwho as
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations , sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as peoplevaccinated 
from Portfolioproject..coviddeaths dea
join Portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
