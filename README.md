### Chase Account Analyzer

A work in progress that I expect I'll extend as my needs become more specific.  

Chase allows one to download account activity as a CSV file.  This program provides a few simple classes for parsing this file into a series of Transaction objects, and rolling those transactions together into a BankHistory object.  Then you can filter the transactions based on their description, start, and end dates and figure out how much you've spent where.   There aren't interfaces yet, besides the script taking a pathname argument for the location of the data.