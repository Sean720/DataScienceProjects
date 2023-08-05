Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (cast(total_deaths as numeric))/(cast(total_cases as numeric))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%africa%'
and continent is not null
order by 1,2

--Looking at Total Cases vs Population

Select Location, date, Population, total_cases, (cast(total_cases as numeric))/(cast(Population as numeric))*100 as InfectionPercentage
From PortfolioProject..CovidDeaths
--Where location like '%africa%'
Where continent is not null
order by 1,2

--Looking at Countries with the highestinfectionrate compared tothe population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((cast(total_cases as numeric))/(cast(Population as numeric)))*100 as InfectionPercentage
From PortfolioProject..CovidDeaths
--Where location like '%africa%'
Where continent is not null
Group by Location, Population
order by InfectionPercentage desc

--Showing countries with highest Death count per population

Select Location, MAX(cast(total_deaths as numeric)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%africa%'
Where continent is not null
Group by Location
order by TotalDeathCount desc


--Sorting by Continent


Select continent, MAX(cast(total_deaths as numeric)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%africa%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



--Global Numbers

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as numeric)) as total_deaths, SUM(cast(new_deaths as numeric))/NULLIF(SUM(new_cases), 0)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%africa%'
Where continent is not null
Group by date
order by 1,2


--Finding Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
 dea.date) as CummulativePeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3



-- Use CTE

With PopvsVac (continent, Location, date, Population, new_vaccinations, CummulativePeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
 dea.date) as CummulativePeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *
From PopvsVac





--TEMP TABLE



DROP Table if exists #PercentPopulationvaccinated
Create Table #PercentPopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
CummulativePeopleVaccinated numeric
)


Insert into #PercentPopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
 dea.date) as CummulativePeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select *
From #PercentPopulationvaccinated


--Creating view to store data for later visualization

Create View PercentPopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
 dea.date) as CummulativePeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationvaccinated