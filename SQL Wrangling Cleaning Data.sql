/*

Data Wrangling/Cleaning/Manipulation

*/


--SaleDate are reversed from datetime format to date format.

Select *
From NashvilleHousing

SELECT NewSaleDate, convert(Date, SaleDate)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
Add NewSaleDate Date;

Update NashvilleHousing
SET NewSaleDate = CONVERT(Date,SaleDate)

-- Deleting SaleDate Column

ALTER table NashvilleHousing
DROP column SaleDate

--Populate Data

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAdress, b.PropertyAddress)
FROM NashvilleHousing  a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.uniqueID <> b.uniqueID
WHERE a.PropertyAddress is null



UPDATE a
SET PropertyAddress = b.PropertyAddress
FROM NashvilleHousing a
LEFT JOIN NashvilleHousing b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;


--Seperating the Adress column into Individual Columns

SELECT PropertyAddress
FROM NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)) As Address
FROM NashvilleHousing


SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM 
    NashvilleHousing;



ALTER table NashvilleHousing
ADD AddressComponent Varchar(255)

UPDATE NashvilleHousing
SET AddressComponent = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress))


ALTER table NashvilleHousing
ADD City Varchar(255)

UPDATE NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


SELECT *
FROM NashvilleHousing


ALTER table NashvilleHousing 
DROP Column PropertyAddress

SELECT OwnerAddress
FROm NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerStreet Varchar(255)

UPDATE NashvilleHousing
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerCity Varchar(255)

UPDATE NashvilleHousing
SET OwnerCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerState Varchar(255)

UPDATE NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT *
FROm NashvilleHousing

ALTER Table NashvilleHousing
DROP column OwnerAddress


SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant
Order by 2

SELECT SoldAsVacant
, CASE   
       WHEN SoldAsVacant = 'Y' THEN 'YES'
	   WHEN SoldASVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing
      

Update NashvilleHousing
SET SoldAsVacant = CASE   
       WHEN SoldAsVacant = 'Y' THEN 'YES'
	   WHEN SoldASVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Removing Duplicates
--Fuinding the duplicates with CTE

WITH RowNumTAble AS(

SELECT *,
       ROW_NUMBER() OVER (
	   PARTITION BY ParcelID,
	                AddressComponent,
					SalePrice,
					NewSaleDate,
					LegalReference
					ORDER BY
					      UniqueID
						  ) row_num
FROM NashvilleHousing)
SELECT *
FROM RowNumTAble
WHERE row_num >1
ORDER BY AddressComponent




WITH RowNumTAble AS(

SELECT *,
       ROW_NUMBER() OVER (
	   PARTITION BY ParcelID,
	                AddressComponent,
					SalePrice,
					NewSaleDate,
					LegalReference
					ORDER BY
					      UniqueID
						  ) row_num
FROM NashvilleHousing)
DELETE
FROM RowNumTAble
WHERE row_num >1
