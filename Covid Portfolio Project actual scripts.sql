select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4



select * 
from PortfolioProject..CovidVaccinations
order by 3,4

--- Select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


--- Looking at Total Cases vs Total Deaths
--- Shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (cast(total_deaths as int)/(cast(total_cases as int)))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
and continent is not null
order by 1,2


--- Looking at Total Cases vs Population
--- Shows what percentage of population got covid
select location, date,population , total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2


--- Looking at countries with Highest Infection Rate compared to Population
select location,population , MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group BY Location, Population
order by PercentPopulationInfected desc


-- SHowing Countries with Highest Death Count per Population

select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
 From  PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group BY Location
order by TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

select CONTINENT, MAX(cast(Total_deaths as int)) as TotalDeathCount
 From  PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group BY CONTINENT
order by TotalDeathCount desc

select LOCATION, MAX(cast(Total_deaths as int)) as TotalDeathCount
 From  PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group BY LOCATION
order by TotalDeathCount desc



---- SHowing continents with the highest death count per population

select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
 From  PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group BY continent
order by TotalDeathCount desc


--- Global Numbers (Query not working)

Select date, SUM(new_cases) as total_cases , SUM(cast(new_deaths as int)) as total_deaths , SUM(cast(New_deaths as int))/SUM
 (New_cases)*100 as DeathPercentage-- total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by date having sum(new_cases)>0
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/SUM
 (New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


Select *
From PortfolioProject..CovidVaccinations


select * 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date


--- Looking at Total Population vs Vaccinations

select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidVaccinations dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--- Looking at Total Population vs Vaccinations (Query not working)


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(cast(isnull(vac.new_vaccinations,0) as int)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
and dea.date < '22jun2021'
--and vac.new_vaccinations is not null
order by 2,3


select distinct max(len(trim(new_vaccinations))),max(convert(int,new_vaccinations))-- new_vaccinations,isnull(new_vaccinations,0) 
from PortfolioProject..CovidVaccinations
order by 1 desc


--- USE CTE (Query not working)

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
and dea.date < '22jun2021'
)
Select * , (RollingPeopleVaccinated/Population)*100
From PopvsVac


--- TEMP Table
DROP Table if exists #PercentpopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
and dea.date < '22jun2021'
--order by 2,3

Select * , (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--- Creating view to store data for later visualizations
drop view PercentPopulationVaccinated_1
drop view PercentPopulationVaccinated
Create View PercentPopulationVaccinated	as
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
and dea.date < '22jun2021'
--order by 2,3


Select *
From 
PercentPopulationVaccinated

