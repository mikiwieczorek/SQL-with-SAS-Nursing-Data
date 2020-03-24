/*************************************
* Name: SQL procedure in SAS:	      *
*	Management of Structured Data *
*                                     *
* Date: February 25, 2019             *
*                                     *
* Author: Mikolaj Wieczorek	      *
*     	    		  	      *
**************************************/

/** FOR CSV Files uploaded from Windows **/

FILENAME CSV "/folders/myfolders/Med_2/ProviderInfo_Download.csv" TERMSTR=CRLF;

/** Import the CSV file.  **/

PROC IMPORT DATAFILE=CSV
		    OUT=Miki.ProviderInfo
		    DBMS=CSV
		    REPLACE;
		    
		    GETNAMES = Yes;
		    DATAROW = 2;
RUN;

FILENAME CSV;

PROC CONTENTS DATA = Miki.ProviderInfo;
RUN;

*Getting only certain fields;
PROC SQL;
	SELECT PROVNAME, ADDRESS, CITY, STATE, ZIP
	FROM Miki.ProviderInfo;
QUIT;

*Produces equivalent output to SQL commands above;
PROC PRINT DATA = Miki.ProviderInfo;
	VAR PROVNAME ADDRESS CITY STATE ZIP;
RUN;


*Getting only certain fields and only certain rows;
PROC SQL;
	SELECT PROVNAME, ADDRESS, CITY, STATE, ZIP
	FROM Miki.ProviderInfo
	WHERE Zip = '55987';
QUIT;

*Version 1 - Zip;
PROC SQL;
	/* Select count(*) */
	SELECT COUNT(PROVNAME)
	FROM Miki.ProviderInfo
	WHERE Zip = '55987';
QUIT;

PROC SQL;
	SELECT COUNT(PROVNAME)
		   LABEL 'Count in 55987'
	FROM Miki.ProviderInfo
	WHERE Zip = '55987';
QUIT;

PROC SQL;
	SELECT COUNT(*)
	FROM Miki.ProviderInfo
	WHERE State = 'MN';
QUIT;


*Counting number of providers in 7 metro counties;
PROC SQL;
	SELECT COUNT(*) 
	       LABEL = 'Number in 7 Metro Counties'
	FROM Miki.ProviderInfo
	WHERE State = 'MN' AND COUNTY_NAME IN ('Anoka', 'Washington', 'Dakota',
	                                        'Scott', 'Carver', 'Hennepin', 'Ramsey');
QUIT;


PROC SQL;
	SELECT COUNT(*)
		AS MetroCount LABEL = 'Number in 7 Metro Counties',
		CALCULATED MetroCount/(SELECT COUNT(*) FROM Miki.ProviderInfo WHERE State = 'MN')
			AS MetroPer LABEL = 'Percent in Metro Counties'
	FROM Miki.ProviderInfo
	WHERE State = 'MN' AND COUNTY_NAME IN ('Anoka', 'Washington', 'Dakota',
	                                        'Scott', 'Carver', 'Hennepin', 'Ramsey');
QUIT;

PROC SQL;
	SELECT COUNT(*)
		AS MetroCount LABEL = 'Nursing Home Area Codes',
		CALCULATED MetroCount/(SELECT COUNT(*) FROM Miki.ProviderInfo WHERE State = 'MN')
			AS MetroPer LABEL = 'Percent in Metro Counties'
	FROM Miki.ProviderInfo
	WHERE State = 'MN' AND COUNTY_NAME NOT IN ('Anoka', 'Washington', 'Dakota',
	                                        'Scott', 'Carver', 'Hennepin', 'Ramsey');
QUIT;

PROC SQL;
	SELECT COUNT(*)
		AS MetroCount LABEL = 'Nursing Home Area Codes',
		CALCULATED MetroCount/(SELECT COUNT(*) FROM Miki.ProviderInfo WHERE State = 'MN')
			AS MetroPer LABEL = 'Percent in Metro Counties'
	FROM Miki.ProviderInfo
	WHERE State = 'MN' and ((substr(PHONE,1,3) IN ('507', '218', '320')) or (COUNTY_NAME NOT IN ('Anoka', 'Washington', 'Dakota',
	                                        'Scott', 'Carver', 'Hennepin', 'Ramsey'))); 
QUIT;

