/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[Sheet1$]


  --Cleaning Data in SQL Queries

  select *
  from PortfolioProject.dbo.Sheet1$


  --Standardize Data Format

  select SaleDateConverted, CONVERT(Date,SaleDate)
  from PortfolioProject.dbo.NashvilleHousing


  
  ALTER TABLE NashvilleHousing
  Add SaleDateConverted Date


  Update [NashvilleHousing]
  SET SaleDateConverted = CONVERT(Date,SaleDate)


  --Populate Property Address Data
 
 select *
  from PortfolioProject.dbo.NashvilleHousing
 -- where PropertyAddress is null
  order by ParcelID


  select a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProject.dbo.NashvilleHousing a
  Join PortfolioProject.dbo.NashvilleHousing b
  On a.ParcelID = b.ParcelID
  AND a.[UniqueID] <> b.[UniqueID]
  where a.PropertyAddress is null


  update a
  set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProject.dbo.NashvilleHousing a
  Join PortfolioProject.dbo.NashvilleHousing b
  On a.ParcelID = b.ParcelID
  AND a.[UniqueID] <> b.[UniqueID]
  where a.PropertyAddress is null



  --Breaking out Address into individual column (Address, City, State)

  select PropertyAddress
  from PortfolioProject.dbo.NashvilleHousing
  --where PropertyAddress is null
  --order by ParcelID


  select
  substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
  , substring(PropertyAddress,  CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
  from PortfolioProject.dbo.NashvilleHousing



   ALTER TABLE NashvilleHousing
  Add PropertySplitAddress nvarchar(255);


  Update [NashvilleHousing]
  SET  PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) 

  ALTER TABLE NashvilleHousing
  Add PropertySplitCity nvarchar(255)

  Update [NashvilleHousing]
  SET  PropertySplitCity = substring(PropertyAddress,  CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))


  select *
  from PortfolioProject.dbo.NashvilleHousing



  select OwnerAddress
  from PortfolioProject.dbo.NashvilleHousing

  select
  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
  , PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
	, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
	from PortfolioProject.dbo.NashvilleHousing


	ALTER TABLE NashvilleHousing
  Add OwnerSplitAddress nvarchar(255);


  Update [NashvilleHousing]
  SET  OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

  ALTER TABLE NashvilleHousing
  Add OwnerSplitCity nvarchar(255);

  Update [NashvilleHousing]
  SET  OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

   ALTER TABLE NashvilleHousing
  Add OwnerSplitState nvarchar(255);

  Update [NashvilleHousing]
  SET  OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


  --Change Y and N to Yes and No in "Sold as vacant"field

  select Distinct(SoldAsVacant), Count(SoldAsVacant)
  from PortfolioProject.dbo.NashvilleHousing
  Group by SoldAsVacant
  Order by 2


  select SoldAsVacant
 , CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
   WHEN SoldAsVacant ='N' THEN 'No'
  ELSE SoldAsVacant
  END
  from PortfolioProject.dbo.NashvilleHousing

  Update NashvilleHousing
  SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
   WHEN SoldAsVacant ='N' THEN 'No'
  ELSE SoldAsVacant
  END


  --Remove Duplicates

  WITH RowNumCTE AS(
  select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
  PropertyAddress,
  SalePrice,
  SaleDate,
  LegalReference
  ORDER BY
  UniqueID
  ) row_num

  from PortfolioProject.dbo.NashvilleHousing
 -- Order by ParcelID
 )
 DELETE 
  from RowNumCTE
  where Row_num > 1
 -- Order by PropertyAddress

 WITH RowNumCTE AS(
  select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
  PropertyAddress,
  SalePrice,
  SaleDate,
  LegalReference
  ORDER BY
  UniqueID
  ) row_num

  from PortfolioProject.dbo.NashvilleHousing
 -- Order by ParcelID
 )
 select *
  from RowNumCTE
  where Row_num > 1
 -- Order by PropertyAddress



 --Delete Unused cloumns

 select *
 from PortfolioProject.dbo.NashvilleHousing

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


























