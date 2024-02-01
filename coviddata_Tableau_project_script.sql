--1.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/SUM
 (New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--2.
select location , sum(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null
and location not in ('World', 'European Union','International')
Group by location
order by TotalDeathCount desc

--3.
select location, Population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as percentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

--4.
Select location, Population, date, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population,date
order by PercentPopulationInfected desc

