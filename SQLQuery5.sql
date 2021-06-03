Select *
From PortfolioProject..Coviddeaths
order by 3,4

--Select *
--From PortfolioProject..Covidvaccinations
--order by 3,4


--Selecting data which are going to use
Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..Coviddeaths
order by 1,2

--Shows likelihood of dying if you contract with covid in our country
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..Coviddeaths
Where location like '%India%'
order by 1,2

-- What percentage of population got covid

Select location,date,population,total_cases,total_deaths,(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..Coviddeaths
Where location like '%India%'
order by 1,2

--Looking at countries with Highest Infection rate compared to population

Select location, population,Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..Coviddeaths
--Where location like '%India%'
Group by location, population
order by 4 desc

-- Showing countries with Highest Death count per population

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Coviddeaths
--Where location like '%India%'
where continent is not null
Group by location
order by TotalDeathCount desc


-- Showing continents with highest death count

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Coviddeaths
--Where location like '%India%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- GLOBAL Numbers

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..Coviddeaths
--Where location like '%India%'
where continent is not null
Group by date
order by 1,2

Select *
From PortfolioProject..CovidVaccinations

--Looking at Total Populations vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..Coviddeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE

With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..Coviddeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- TEMP TABLE

DROP table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated

(
Continent nvarchar(255),
Location Nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..Coviddeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Creating view


Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..Coviddeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated


