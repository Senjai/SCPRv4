# SCPRv4

This is the codebase for SCPR.org. It is (approximately) the fourth generation 
code for the site, replacing the Python-based Mercer.

## Database

This code assumes that you are starting with the live Mercer database. Migrations 
may create new tables and views of existing tables, but may not modify any table 
structures until the Mercer codebase has been retired.