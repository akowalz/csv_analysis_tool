require 'date'

class Transaction < Struct.new(:type, :date, :description, :amnt)
  def to_s
    "Type: #{type}\nDate: #{date}\nDescription: #{description}\nAmount: #{amnt}"
  end
end
 
def get_transactions(path)
  transactions = []
  File.open(path) do |file|
    file.each_line do |t|
      items = t.split(',')
      next if items[0] == 'Type'
      transactions << convert_to_transaction(items)
    end 
  end
  transactions
end

def convert_to_transaction(items)
  type = items[0]
  date = Date.strptime(items[1], "%m/%d/%Y")
  description = items[2]
  amnt = items[3].to_f
  Transaction.new(type, date, description, amnt)
end

class BankHistory

  def initialize(transactions)  
    @transactions = transactions
  end

  def find_transactions_with_requirements(options={})
    subset = @transactions
    if options[:description]
      subset = find_transactions_with_description(options[:description], subset)
    end
    if options[:start_date] && options[:end_date]
      subset = find_transactions_in_date_range(options[:start_date], options[:end_date],subset) 
    end
    subset
  end

  private

    def find_transactions_with_description(desc,transactions)
      transactions.select do |t|
        t.description.downcase.include?(desc.downcase)
      end
    end

    def find_transactions_in_date_range(start_date,end_date,transactions)
      start_date_obj = Date.strptime(start_date, "%m/%d/%Y")
      end_date_obj = Date.strptime(end_date, "%m/%d/%Y")
      transactions.select do |t|
        (t.date > start_date_obj) && (t.date < end_date_obj)
      end
    end
end



all_transactions = get_transactions(ARGV[0])

history = BankHistory.new(all_transactions)


