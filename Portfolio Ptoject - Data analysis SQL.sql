
-- מספר הנדבקים הגבוהה ביחד לאולוסיה
select Location, population, max(total_cases)as max_total_cases,
max((total_cases/population))*100 as casesPercentage
from PortfolioProject..CovidDeaths
where location like '%Israel%'
Group by population,Location 
order by casesPercentage desc



--מספר המתים הגבוהה ביותר ביחס לאוכלוסיה
select Location, max(cast(Total_deaths as int))as max_total_deaths,
max((total_deaths/population))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%Israel%'
Where continent is not null 
Group by Location 
order by DeathPercentage desc




-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc


--מספר הנדבקים והמתים כל יום
select date, sum(new_cases) as cases_fer_day, sum(cast(new_deaths as int)) as death_fer_day
from PortfolioProject..CovidDeaths
Where continent is not null 
Group by date
order by 1,2

--יצירת מערך אשר סופר לכל יום כמה אנשים התחסנו עד לאותו יום.
-- יודע להפסיק לספור את כמות המתחסנים במעבר בין לוקיישנים שונים.

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location,dea.date) as rollingpeapolevaccinations
from PortfolioProject..CovidDeaths as dea 
join PortfolioProject..CovidVaccinations as vac
on vac.location = dea.location and vac.date = dea.date
Where dea.continent is not null
--Group by dea.location, dea.date
order by 2,3


-- נרצה להשתמש בעמודה החדשה שייצרנו אך לשם כך נצתרך ליוצר טבלה חדשה או טבלת דמה
drop Table if exists #percentpopolationvaccinated
create Table #percentpopolationvaccinated
--
(
continent nvarchar(225),
location nvarchar(225),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeapolevaccinations numeric
)

insert into #percentpopolationvaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location,dea.date) as rollingpeapolevaccinations
from PortfolioProject..CovidDeaths as dea 
join PortfolioProject..CovidVaccinations as vac
on vac.location = dea.location and vac.date = dea.date

 select *, (rollingpeapolevaccinations/population)*100
 from #percentpopolationvaccinated
 order by 2,3

 --יצירת תצוגה לטובת תצוגה מאוחר יותר
create view percentpopolationvaccinated as

 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(int,vac.new_vaccinations)) 
 over (partition by dea.location order by dea.location,dea.date) as rollingpeapolevaccinations
 from PortfolioProject..CovidDeaths as dea 
 join PortfolioProject..CovidVaccinations as vac
 on vac.location = dea.location and vac.date = dea.date




































