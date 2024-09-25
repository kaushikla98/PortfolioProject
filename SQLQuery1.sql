select location, date, total_cases,new_cases, total_deaths, population
from CovidDeaths
order by 1,2;

--Looking at Total Cases Vs Total Deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100
from CovidDeaths
order by 1,2;

-- Shows the likelihood of dying if you contact covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100
from CovidDeaths
where location like '%india%'
order by 1,2;

-- Shows what percentage of population got covid
select location, date, population, total_cases, (total_cases/population)*100 as PercentInfectedage
from CovidDeaths
--where location like '%india%'
order by 1,2;


-- what country had the highest infection rate compared to population
select location, population, max ( total_cases) as HighestInfectionCount, (Max(total_cases/population))*100 as PercentInfected
from CovidDeaths
--where location like '%india%'
group by location, population
order by  PercentInfected desc;

--Lets's break things down by continent
select continent, MAX(cast(Total_deaths as int)) as totaldeathcount
from CovidDeaths
where continent is not null
group by continent
order by  totaldeathcount desc;

-- Showing the continents with the highest deathCounts
--Showing the country with the highest death count per population
select location, MAX(cast(Total_deaths as int)) as totaldeathcount
from CovidDeaths
where continent is not null
group by location
order by  totaldeathcount desc;


select location, MAX(cast(Total_deaths as int)) as totaldeathcount
from CovidDeaths
where continent is null
group by location
order by  totaldeathcount desc;



-- Global Numbers

select sum(new_cases) as totalcases , sum(cast(new_deaths as int)) as totaldeaths, sum (new_deaths )/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
--where location like '%india%'
where continent is not null
--group by date
order by 1,2;



-- Looking at total population Vs Vaccinations

-- Use CTE
with PopvsVac (contient, location, date,population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert (int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/ population)*100
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea. date = vac.date
where dea.continent is not null
--order by 2,3
)

select*, (RollingPeopleVaccinated/population)*100
from PopvsVac


-- temp table 


drop table if exists #PercentagePopulationVaccinated

create table #PercentagePopulationVaccinated

(
continent nvarchar(25),
location nvarchar(225),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentagePopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert (int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/ population)*100
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea. date = vac.date
--where dea.continent is not null
--order by 2,3

select*, (RollingPeopleVaccinated/population)*100
from #PercentagePopulationVaccinated






-- creating view to store data for later visualizations

Create View PercentagePopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert (int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/ population)*100
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea. date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentagePopulationVaccinated

