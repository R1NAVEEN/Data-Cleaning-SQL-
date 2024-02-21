/*
1. Cleaning Data in SQL Queries
*/
select *
from PortofolioProject..NashvilleHousing2

/*
2.Standardize Date Format
*/
select SaleDate, convert(Date, SaleDate)
from PortofolioProject..NashvilleHousing2


-- Let's Update 

Alter Table NashvilleHousing2
Add SaleDateConverted Date;

Update NashvilleHousing2
Set SaleDateConverted = convert(Date, SaleDate)

Select SaleDateConverted, Convert(Date, SaleDate)
From PortofolioProject..NashvilleHousing2


/*
3.Populate Property Address Data
*/
select *
from PortofolioProject..NashvilleHousing2
--Where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, Isnull(a.PropertyAddress, b.PropertyAddress)
from PortofolioProject..NashvilleHousing2 a
Join PortofolioProject..NashvilleHousing2 b
On a.ParcelID = b.ParcelID
And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is Null


-- lets update

update a 
Set PropertyAddress = Isnull(a.PropertyAddress, b.PropertyAddress)
from PortofolioProject..NashvilleHousing2 a
Join PortofolioProject..NashvilleHousing2 b
On a.ParcelID = b.ParcelID
And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is Null



/*
4. Breaking out Address into Individual Columns(Address, City, State)
*/
select PropertyAddress
from PortofolioProject..NashvilleHousing2
--Where PropertyAddress is null
--order by ParcelID


Select
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) as Address
from PortofolioProject..NashvilleHousing2


Alter Table NashvilleHousing2
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing2
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)


Alter Table NashvilleHousing2
Add PropertySplitCity nvarchar(255)

Update NashvilleHousing2
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress))

Select*
from PortofolioProject..NashvilleHousing2





Select OwnerAddress
from PortofolioProject..NashvilleHousing2



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortofolioProject..NashvilleHousing2


Alter Table NashvilleHousing2
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing2
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


Alter Table NashvilleHousing2
Add OwnerSplitCity nvarchar(255)

Update NashvilleHousing2
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Alter Table NashvilleHousing2
Add OwnerSplitState nvarchar(255)

Update NashvilleHousing2
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select*
from PortofolioProject..NashvilleHousing2



/*
5. Change Y and N to Yes and No in "SoldasVacant" field
*/

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortofolioProject..NashvilleHousing2
group by SoldAsVacant
order by SoldAsVacant



Select SoldAsVacant
 , Case When SoldAsVacant ='Y' Then 'Yes'
  When SoldAsVacant = 'N' Then 'No'
  ELSE SoldAsVacant
  END
from PortofolioProject..NashvilleHousing2



Update NashvilleHousing2
Set SoldAsVacant = Case When SoldAsVacant ='Y' Then 'Yes'
  When SoldAsVacant = 'N' Then 'No'
  ELSE SoldAsVacant
  END


select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortofolioProject..NashvilleHousing2
group by SoldAsVacant
order by SoldAsVacant



/*
6. Remove Duplicates
*/

with RowNumCTE as(
select *,
ROW_NUMBER() over(
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by UniqueID) row_num
from PortofolioProject..NashvilleHousing2
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress


-- lets delete duplicates
with RowNumCTE as(
select *,
ROW_NUMBER() over(
partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by UniqueID) row_num
from PortofolioProject..NashvilleHousing2
--order by ParcelID
)
Delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress




/*
7. Delete Unused Columns
*/

select *
from PortofolioProject..NashvilleHousing2



Alter Table PortofolioProject..NashvilleHousing2
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortofolioProject..NashvilleHousing2
Drop Column SaleDate