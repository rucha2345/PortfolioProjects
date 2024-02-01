

--Cleaning Data in SQL queries

Select *
From PortfolioProject.dbo.Nashville_Housing_V2


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Standardize Date Format

Select SaleDateConverted , convert(Date, SaleDate)
From PortfolioProject.dbo.Nashville_Housing_V2


Update Nashville_Housing_V2
SET SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE Nashville_Housing_V2
Add SaleDateConverted Date;


Update Nashville_Housing_V2
SET SaleDateConverted = convert(Date, SaleDate)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Populate Property Address data

Select PropertyAddress
From PortfolioProject.dbo.Nashville_Housing_V2
where PropertyAddress is null

Select *
From PortfolioProject.dbo.Nashville_Housing_V2
where PropertyAddress is null


Select *
From PortfolioProject.dbo.Nashville_Housing_V2
--where PropertyAddress is null
order by ParcelID


Select a.PArcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.Nashville_Housing_V2 a
JOIN PortfolioProject.dbo.Nashville_Housing_V2 b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null



Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.Nashville_Housing_V2 a
JOIN PortfolioProject.dbo.Nashville_Housing_V2 b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.Nashville_Housing_V2
--where PropertyAddress is null
--order by PArcelID


Select
Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.Nashville_Housing_V2





ALTER TABLE Nashville_Housing_V2
Add PropertySplitAddress Nvarchar(255);


Update Nashville_Housing_V2
SET PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE Nashville_Housing_V2
Add PropertySplitCity Nvarchar(255);


Update Nashville_Housing_V2
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 



select PropertyAddress,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 
From PortfolioProject.dbo.Nashville_Housing_V2






select OwnerAddress
From PortfolioProject.dbo.Nashville_Housing_V2

Select 
Parsename(REPLACE(OwnerAddress,',','.'), 3)
,Parsename(REPLACE(OwnerAddress,',','.'), 2)
,Parsename(REPLACE(OwnerAddress,',','.'), 1)
From PortfolioProject.dbo.Nashville_Housing_V2



ALTER TABLE Nashville_Housing_V2
Add OwnerSplitAddress Nvarchar(255);


Update Nashville_Housing_V2
SET OwnerSplitAddress = Parsename(REPLACE(OwnerAddress,',','.'), 3)


ALTER TABLE Nashville_Housing_V2
Add OwnerSplitCity Nvarchar(255);


Update Nashville_Housing_V2
SET OwnerSplitCity = Parsename(REPLACE(OwnerAddress,',','.'), 2)



ALTER TABLE Nashville_Housing_V2
Add OwnerSplitState Nvarchar(255);


Update Nashville_Housing_V2
SET OwnerSplitState = Parsename(REPLACE(OwnerAddress,',','.'), 1)



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVAcant)
From PortfolioProject.dbo.Nashville_Housing_V2
Group By SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From PortfolioProject.dbo.Nashville_Housing_V2



Update Nashville_Housing_V2
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--Remove Duplicates


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

From PortfolioProject.dbo.Nashville_Housing_V2
--order by ParcelID
)
Select *
from RowNumCTE
where row_num > 1
Order by PropertyAddress





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

From PortfolioProject.dbo.Nashville_Housing_V2
--order by ParcelID
)
DELETE
from RowNumCTE
where row_num > 1
--Order by PropertyAddress


Select * 
from PortfolioProject.dbo.Nashville_Housing_V2



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Delete Unused Columns

Select *
From PortfolioProject.dbo.Nashville_Housing_V2


Alter Table PortfolioProject.dbo.Nashville_Housing_V2
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress



Alter Table PortfolioProject.dbo.Nashville_Housing_V2
DROP COLUMN SaleDate


