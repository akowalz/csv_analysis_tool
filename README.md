### Analyze CSV Data

This is a tool I wrote in order to figure out more about my banking history.  My bank allowed me to download my transaction history data as a CSV file with transactions of the form:

`type,date,description,amount`

on each line.  So, by parsing through the lines and data on each line, I can get a set of all my transactions.

Why not do this in Excel you might ask?  That's a great question.  This mostly just for fun and as an excersize using Ruby.  Other than that, there isn't really a good reason for it.

The code implements two classes, `BankHistory` and a subclass `Transaction` to analyze the files. Transaction is mostly just a struct to put the info about each transaction, and BankHistory is a set of these transactions with methods to analyze the set.

The most forward-facing public method is `sum_with_requirements` in `analyze_money.rb`.  It will analyze the current banking history with options provided by the user. Available options currently include start date, end date, amount, and description.  It's main purpose is finding the total amount spent on transactions that meet the requirements. 


Also included are unit tests I used for the project.  They are not exhaustive, but test of the basic functionality of the tool.  They operate on a test CSV file, which is also included in the repository.

What I want to do next is make a proper interface for this so I can use it as a commandline tool. Right now it's a bit clunky to use, but works as intended.