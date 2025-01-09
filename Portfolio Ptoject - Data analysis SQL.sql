
-- The number of people infected with the Corona virus is high in relation to the population in Israel
select Location, population, max(total_cases)as max_total_cases,
max((total_cases/population))*100 as casesPercentage
from PortfolioProject..CovidDeaths
where location like '%Israel%'
Group by population,Location 
order by casesPercentage desc;



-- Highest number of deaths relative to population
select Location, max(cast(Total_deaths as int))as max_total_deaths,
max((total_deaths/population))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%Israel%'
Where continent is not null 
Group by Location 
order by DeathPercentage desc;




-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc;


-- Number of infections and deaths every day
select date, sum(new_cases) as cases_fer_day, sum(cast(new_deaths as int)) as death_fer_day
from PortfolioProject..CovidDeaths
Where continent is not null 
Group by date
order by 1,2;

-- Creating a system that counts each day how many people have been vaccinated until that day.-- יודע להפסיק לספור את כמות המתחסנים במעבר בין לוקיישנים שונים.
-- Knows how to stop counting the number of people vaccinated when moving between different locations.
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(int,vac.new_vaccinations)) 
 over (partition by dea.location order by dea.location,dea.date) as rollingpeapolevaccinations
 from PortfolioProject..CovidDeaths as dea 
 join PortfolioProject..CovidVaccinations as vac
 on vac.location = dea.location and vac.date = dea.date
 Where dea.continent is not null
--Group by dea.location, dea.date
 order by 2,3;


-- We would like to use the new column we created, 
-- but for this we will need to create a new table or a dummy tabledrop Table if exists #percentpopolationvaccinated
create Table #percentpopolationvaccinated
--
(
continent nvarchar(225),
location nvarchar(225),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeapolevaccinations numeric
);


insert into #percentpopolationvaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(int,vac.new_vaccinations)) 
 over (partition by dea.location order by dea.location,dea.date) as rollingpeapolevaccinations
 from PortfolioProject..CovidDeaths as dea 
 join PortfolioProject..CovidVaccinations as vac
 on vac.location = dea.location and vac.date = dea.date;

select *, (rollingpeapolevaccinations/population)*100
 from #percentpopolationvaccinated
 order by 2,3;

--Creating a view for later viewingcreate view percentpopolationvaccinated as

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(int,vac.new_vaccinations)) 
 over (partition by dea.location order by dea.location,dea.date) as rollingpeapolevaccinations
 from PortfolioProject..CovidDeaths as dea 
 join PortfolioProject..CovidVaccinations as vac
 on vac.location = dea.location and vac.date = dea.date;
