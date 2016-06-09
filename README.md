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
