--Standardize Date Format
SelectsaleDateConverted, CONVERT(Date,SaleDate)
FromPortfolioProject.dbo.NashvilleHousing

UpdateNashvilleHousing
SET SaleDate =CONVERT(Date,SaleDate)

--If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UpdateNashvilleHousing
SET SaleDateConverted =CONVERT(Date,SaleDate)
 --------------------------------------------------------------------------------------------------------------------------

--Populate Property Address data

Select*
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order byParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <>b.[UniqueID ]
Where a.PropertyAddressis null

Update a
SET PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <>b.[UniqueID ]
Where a.PropertyAddressis null

-----------------------------------------------------------------------------------------------------------------------
-- Breaking out address into individual columns (Address,city,State)

select *
from NashvilleHousing

select PropertyAddress
from NashvilleHousing

---
select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1), --Virgüle kadar ilk deðeri çekiyor
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) as Address
from NashvilleHousing

--datayý parçalara bölüp sonunçlarý yeni oluþturduðumuz kolonlara aktaracaðýz

--Adress
alter table  NashvilleHousing
--add propertySplitAddress nvarchar(255);
add ownerSplitAddress nvarchar(255);

update NashvilleHousing
set ownerSplitAddress=parsename(replace(OwnerAddress,',','.'),3)

--City
alter table NashvilleHousing
--add propertySplitCity nvarchar(255);
 add ownerSplitCity nvarchar(255);

update NashvilleHousing
set ownerSplitCity =parsename(replace(OwnerAddress,',','.'),2)

--State
alter table NashvilleHousing
 add ownerSplitState nvarchar(255);

 update NashvilleHousing
set ownerSplitState =parsename(replace(OwnerAddress,',','.'),1)


select *
from ..NashvilleHousing

--PARSENAME	 iþlemiyle de ayýrma iþlemini yapabiliyoruz ama parametreleri tersten belirliyoruz. 
--3 parçaya bölünmüþ metinde 3 numaralý yer ilk parametre olarak belirleniyor.SUBSTRING'den daha basit vir yöntem
select OwnerAddress,
parsename(replace(OwnerAddress,',','.'),3) as One,
parsename(replace(OwnerAddress,',','.'),2)as Two,
parsename(replace(OwnerAddress,',','.'),1)as Three
from ..NashvilleHousing

----------------------------------------------------
-- Change Y and N with Yes and No in "Sold as Vacant" Field
select SoldAsVacant,COUNT(SoldAsVacant)
from ..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
	 when SoldAsVacant='N' then 'No'
	 else SoldAsVacant
	 end
 from ..NashvilleHousing

 update NashvilleHousing
  set SoldAsVacant=
  case when SoldAsVacant='Y' then 'Yes'
	   when SoldAsVacant='N' then 'No'
	   else SoldAsVacant
	   end

	 ----------------------------------------------------
	 --Removing the duplicates
	 with RoWNumberCTE as (
	 select*,ROW_NUMBER() over (
	 partition by parcelId,
	 propertyaddress,
	 saleprice,
	 saledate,
	 legalreference 
	 order by uniqueID
	 ) 
	 row_num
	 from ..NashvilleHousing
	 )
	 select * from RoWNumberCTE

	 
	 ----------------------------------------------------
	 --Deleting unused columns
	 select * 
	 from ..NashvilleHousing

	 ALTER TABLE ..NashvilleHousing
	 drop column taxDistrict,OwnerAddress