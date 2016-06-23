# ACCrashData
Allegheny County Crash Data 2004 - 2014 from wprdc

# Background
The data is from wprdc. I download all the csv files, saved them as Excel 97-2003 files and used the SQL Server 2012 SSIS option to create and load the data into a SQL Server database. I used the SQL Server table design copy to setup up a progress create SQL changing the column names and attributes to match PostgreSQL. I export the data from the SQL Server DB as a csv file. I created the table in PostgreSQL DB and did an import of the data. There were two errors in the original load: an invalid character which I removed from the csv file and an invalid column name OFFSET which is a key word in PostgreSQL.

# Create DB table
This SQL script is no where near ideal. Numbers are double, character lengths at max, no primary key etc. So tweeking of the create table will be an upcoming task. 
## Update: There is a new create table SQL that handles previous concerns

# Needing additional tables
If you looked at the spreadsheet that has the column descriptions you'll see what the values mean. We'll need to create related tables to support these values.

#Normalization
I wonder if for the future we should try to normalize this data. There are a lot of columns with duplicated data. So, you DBA's are on notice.

#Sample scripts
select bicycle_death_count,street_name,count(bicycle_death_count) 
from accrashdata
where bicycle_death_count = 1
group by bicycle_death_count,street_name

select bicycle_maj_inj_count, street_name,count(bicycle_maj_inj_count)
from accrashdata
where bicycle_maj_inj_count > 0
group by bicycle_maj_inj_count,street_name

select bicycle_count,street_name,count(bicycle_count)
from accrashdata
where bicycle_count > 0
group by bicycle_count,street_name
order by count(bicycle_count) desc

select bicycle,street_name,count(bicycle)
from accrashdata
where bicycle = 1
group by bicycle,street_name
order by count(bicycle) desc

select street_name, count(street_name)
from accrashdata
group by street_name
order by count(street_name) desc

select crash_year, count(crash_year)
from accrashdata
group by crash_year
order by crash_year

select dec_lat,dec_long
from accrashdata
where bicycle = 1
and (dec_lat > 0)


#Information Update

The Open Pittsburgh AWS version access will be restricted since the WPRDC has uploaded the 10 years of data on their site
https://data.wprdc.org/dataset/allegheny-county-crash-data

Look over their API for data downloading.

#Complete data arrived

Open Pittsburgh has received 2010-2014 files have been removed. Some data columns have to be removed before reloading. Stay tuned.

#Access Data Update

I've loaded the Access data into SQL Server 2012 as the first step of many to get the data into PostgreSQL. New text version of the All Access DB Data Dictionary has been uploaded. The next goal is to create required create SQL scripts and test load the data in the Open Pittsburgh AWS PostgreSQL account.

#Crash Data Plots

Mike Feyder has added plotted examples. Check it out
