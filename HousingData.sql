/* SQL Data Cleaning for a Housing Data */

/* Viewing Columns of Data */
SELECT * 
FROM SandeepSQL.dbo.Housing 

SELECT SaleDate, CONVERT(Date,SaleDate) as ConvertedDate
FROM SandeepSQL.dbo.Housing 

/* The Above Query Results in Standard Date Format
SaleDate	            ConvertedDate
2013-04-09 00:00:00.000	2013-04-09
2014-06-10 00:00:00.000	2014-06-10
2016-09-26 00:00:00.000	2016-09-26
2016-01-29 00:00:00.000	2016-01-29
2014-10-10 00:00:00.000	2014-10-10
2014-07-16 00:00:00.000	2014-07-16
2014-08-28 00:00:00.000	2014-08-28
2016-09-27 00:00:00.000	2016-09-27 

Now we will Update The Date Column and alter the same into our Table
*/

Update Housing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Housing
ADD StandardDate Date; 

Update Housing
SET StandardDate = CONVERT(Date,SaleDate)

Select StandardDate,SaleDate 
From Housing


/* We Have Successfully have Added New Column With Standard Date Format into our Housing Table
StandardDate	SaleDate
2013-04-09	2013-04-09 00:00:00.000
2014-06-10	2014-06-10 00:00:00.000
2016-09-26	2016-09-26 00:00:00.000
2016-01-29	2016-01-29 00:00:00.000
2014-10-10	2014-10-10 00:00:00.000
2014-07-16	2014-07-16 00:00:00.000
2014-08-28	2014-08-28 00:00:00.000
2016-09-27	2016-09-27 00:00:00.000
2015-08-14	2015-08-14 00:00:00.000 */

----------------------------------------------------------------------------------------------------------------------
/*We need TO also Populate Address in property Address as it has many NUll Values*/
SELECT *
FROM Housing 
WHERE PropertyAddress is NUll

/*
UniqueID 	ParcelID	    LandUse	                PropertyAddress	SaleDate	SalePrice	LegalReference	SoldAsVacant
43076	025 07 0 031.00	    SINGLE FAMILY	        NULL	        2016-01-15 00:00:00.000	179900	20160120-0005776	No
39432	026 01 0 069.00	    VACANT RESIDENTIAL LAND	NULL			2015-10-23 00:00:00.000	153000	20151028-0109602	No
45290	026 05 0 017.00	    SINGLE FAMILY	        NULL			2016-03-29 00:00:00.000	155000	20160330-0029941	No
53147	026 06 0A 038.00	RESIDENTIAL CONDO	    NULL			2016-08-25 00:00:00.000	144900	20160831-0091567	No
43080	033 06 0 041.00	    SINGLE FAMILY	        NULL			2016-01-04 00:00:00.000	170000	20160107-0001526	No

Let us Now Populate the NULL Values with Reference to parcelID was Same To many Addresses*/

Select H1.ParcelID,H1.PropertyAddress , H2.ParcelID, H2.PropertyAddress, ISNULL(H1.PropertyAddress,H2.PropertyAddress) as PopulatedCOL
From Housing H1
JOIN Housing H2
	on H1.ParcelID = H2.ParcelID
	AND H1.[UniqueID ]<> H2.[UniqueID ]

Where H1.PropertyAddress is NUll
/* So Now the PopulatedCOl has All the Values which matches the parcel ID in H2.Property add and Fills the Address in H1.property address wherever 
we have NUll Values in it

ParcelID			PropertyAddress	ParcelID				PropertyAddress						PopulatedCOL
025 07 0 031.00		NULL			025 07 0 031.00			410	ROSEHILL CT, GOODLETTSVILLE		410  ROSEHILL CT, GOODLETTSVILLE
026 01 0 069.00		NULL			026 01 0 069.00			141 TWO MILE PIKE, GOODLETTSVILLE	141  TWO MILE PIKE, GOODLETTSVILLE
026 05 0 017.00		NULL			026 05 0 017.00			208	EAST AVE, GOODLETTSVILLE		208  EAST AVE, GOODLETTSVILLE
026 06 0A 038.00	NULL			026 06 0A 038.00		109  CANTON CT, GOODLETTSVILLE		109  CANTON CT, GOODLETTSVILLE 
Let us now Upadate the same In our Table */

UPDATE H1
SET PropertyAddress = ISNULL(H1.PropertyAddress,H2.PropertyAddress)
From Housing H1
JOIN Housing H2
	on H1.ParcelID = H2.ParcelID
	AND H1.[UniqueID ]<> H2.[UniqueID ]

Select *
From Housing

/*This Is How Updated Property Address looks Like now 
UniqueID 	ParcelID	LandUse			PropertyAddress						SaleDate				SalePrice	LegalReference
2045	007 00 0 125.00	SINGLE FAMILY	1808  FOX CHASE DR, GOODLETTSVILLE	2013-04-09 00:00:00.000	240000		20130412-0036474
16918	007 00 0 130.00	SINGLE FAMILY	1832  FOX CHASE DR, GOODLETTSVILLE	2014-06-10 00:00:00.000	366000		20140619-0053768
54582	007 00 0 138.00	SINGLE FAMILY	1864 FOX CHASE  DR, GOODLETTSVILLE	2016-09-26 00:00:00.000	435000		20160927-0101718
43070	007 00 0 143.00	SINGLE FAMILY	1853  FOX CHASE DR, GOODLETTSVILLE	2016-01-29 00:00:00.000	255000		20160129-0008913
22714	007 00 0 149.00	SINGLE FAMILY	1829  FOX CHASE DR, GOODLETTSVILLE	2014-10-10 00:00:00.000	278000		20141015-0095255 */


-----------------------------------------------------------------------------------------------------------------------------------------------

--We Need to Set Standard and Homogenous Values to Column to a column for easy Data Processing
--Let's check Sold as vacant Column

SELECT Distinct(SoldAsVacant),Count(SoldAsVacant) as NumberOfValues
from Housing 
Group by SoldAsVacant
Order by 2
 /*
 SoldAsVacant	NumberOfValues
Y				52
N				399
Yes				4623
No				51403
 */
--We Need to Convert this Y and N values to Yes and No Respectively

SELECT SoldAsVacant
	,Case When SoldAsVacant = 'Y' Then 'Yes'
		  When SoldAsVacant = 'N' Then 'No'
		  ELSE SoldAsVacant
		  END
From Housing

--This Worked For N and Y values Now Lets Update in Housing Table

Update Housing
SET SoldAsVacant = 
	Case When SoldAsVacant = 'Y' Then 'Yes'
		  When SoldAsVacant = 'N' Then 'No'
		  ELSE SoldAsVacant
		  END

/* We Recieved the Following Results after Upadting Values in table
SoldAsVacant	NumberOfValues
Yes				4675
No				51802
*/

----------------------------------------------------------------------------------------------------------------------------

-- Dropping Unused Columns , We can Do this In Views and Not to be Done on Raw Data. 

SELECT *
FROM Housing

ALTER TABLE Housing
DROP COlUMN SaleDate,TaxDistrict

-- This is just Example of just If we have VIEWS and have Transformed COLs into another More Useable Formats then We can DROP them For More Easier 
--Data Processing. eg. We Deleted Sale Date because we already had it converted into StandardDate Format.
-- This needs to be Done Sometimes for lesser Processing time in ML Models and Can Optimize the Process.


















































-----End------