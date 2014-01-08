require 'date'

# Base class that holds data about a certain group a transactions 
class BankHistory

  class Transaction < Struct.new(:type, :date, :description, :amnt)
    def to_s
      "Type: #{type}\nDate: #{date}\nDescription: #{description}\nAmount: #{amnt}"
    end
  end

  # Maybe the only tricky part of the code, the initialize method actually
  # takes a path to a csv file, not just a value, maybe this is bad practice..
  # But it's good for my purposes, which are just analyzing these specific files
  def initialize(path)  
    @transactions = file_to_transaction_set(path)
  end

  # Main public method, finds a subset of all transactions in the BankHistory object
  # based on options given to it.  This method is very easily extendable
  def get_with_requirements(options={})
    subset = @transactions

    if options[:description]
      subset = find_transactions_with_description(options[:description],subset)
    end

    if options[:start_date] 
      subset = find_after_start_date(options[:start_date],subset)
    end

    if options[:end_date] 
      subset = find_before_end_date(options[:end_date],subset)
    end

    if options[:amount]
      subset = find_specified_amount(options[:amount],subset)
    end

    subset
  end

  # Just a wrapper for the above method that will additionally sum up all the amounts
  def sum_with_requirements(options={})
    sum_transactions get_with_requirements(options)
  end

  private

    # Takes a string or an array, with an array, all strings will be searched for
    def find_transactions_with_description(desc,transactions)
      subset = transactions
      if desc.is_a?(String) 
        subset = subset.select do |t|
          t.description.downcase.include?(desc.downcase)
        end
      elsif desc.is_a?(Array)
        subset = subset.select do |t|
          desc.any? { |d| t.description.downcase.include?(d) }
        end
      end
      subset
    end

    def find_after_start_date(start_date,transactions)
      start_date = Date.strptime(start_date, "%m/%d/%Y") if start_date.is_a?(String)
      transactions.select { |t| t.date >= start_date }
    end

    def find_before_end_date(end_date,transactions)
      end_date = Date.strptime(end_date, "%m/%d/%Y") if end_date.is_a?(String)
      transactions.select { |t| t.date <= end_date }
    end

    # Very similar to find with description, in that it takes both a string and an array
    # I have a feeling with some block and yield magic I could refactor those two methods
    def find_specified_amount(amnt,transactions)
      subset = transactions
      if amnt.is_a?(Float) || amnt.is_a?(Fixnum)
        subset = subset.select { |t| t.amnt == amnt }
      elsif amnt.is_a?(Array)
        subset = subset.select do |t|
          amnt.any? { |a| t.amnt == a }
        end
      end
      subset
    end

    def sum_transactions(transactions)
       transactions.inject(0) { |total, t| total + t.amnt} # gotta love inject
    end    

    # Takes an array of items and converts them into a transaction object
    def convert_to_transaction(items)
      type = items[0]
      date = Date.strptime(items[1], "%m/%d/%Y") 
      description = items[2]
      amnt = items[3].to_f
      Transaction.new(type, date, description, amnt)
    end

    # Takes the CSV file and turns it into transaction objects
    def file_to_transaction_set(path)
      transactions = []
      File.open(path) do |file|
        file.each_line do |t|
          items = t.split(',')
          next if items[0] == 'Type' #special case for the description line
          transactions << convert_to_transaction(items)
        end 
      end
      transactions
    end
end
