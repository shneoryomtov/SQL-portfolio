SELECT *
from [dbo].[NashvilleHousing]

-- Creating a new column of type datetime
Alter Table NashvilleHousing
add SaleDateConvert date;

--Placement of the old date in the column we created
update NashvilleHousing 
Set SaleDateConvert = convert(date,SaleDate)


-- Checking which columns have missing values that 
-- can be completed based on the existing information.


select a.PropertyAddress, b.PropertyAddress
from [dbo].[NashvilleHousing] as a 
join [dbo].[NashvilleHousing] as b
on a.[ParcelID] = b.[ParcelID] and a.[UniqueID ]<>b.[UniqueID ]
where b.PropertyAddress is null or a.PropertyAddress is null 

-- In our case, ID is a key, so if that ID is missing,
-- the address can be completed from another sample

update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [dbo].[NashvilleHousing] as a 
join [dbo].[NashvilleHousing] as b
on a.[ParcelID] = b.[ParcelID] and a.[UniqueID ]<>b.[UniqueID ]

-- Split address into city and address in 2 different columns
select SUBSTRING([PropertyAddress],1,charindex(',',[PropertyAddress])-1) as addres
,SUBSTRING([PropertyAddress],charindex(',',[PropertyAddress])+1,LEN([PropertyAddress])) as city
,[PropertyAddress]
from [dbo].[NashvilleHousing] 



select [OwnerAddress]
from [dbo].[NashvilleHousing]
where [OwnerAddress] is not null

-- Another way to split the record is by replacing - "," with a dot.
Alter Table NashvilleHousing
add Owner_city nvarchar(255);

update NashvilleHousing 
Set Owner_city = PARSENAME(replace([OwnerAddress],',','.'),2)

select *
from [dbo].[NashvilleHousing]

--Single value presentation and counting of the values in the column

select distinct [SoldAsVacant],count([SoldAsVacant])
from [dbo].[NashvilleHousing]
group by [SoldAsVacant]
order by 2

--The arrangement of the information into identical values
select 
 case when [SoldAsVacant] = 'Y' then 'Yes'
      when [SoldAsVacant] = 'N' then 'NO'
	  else [SoldAsVacant]
	  end
from [dbo].[NashvilleHousing]

update NashvilleHousing 
Set [SoldAsVacant] = case when [SoldAsVacant] = 'Y' then 'Yes'
      when [SoldAsVacant] = 'N' then 'NO'
	  else [SoldAsVacant]
	  end


select distinct [SoldAsVacant],count([SoldAsVacant])
from [dbo].[NashvilleHousing]
group by [SoldAsVacant]
order by 2


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress





Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress







alter table [dbo].[NashvilleHousing]
drop column [PropertyAddress]
















