require "../analyze_money.rb"
require "test/unit"



class TestMoneyAnalysis < Test::Unit::TestCase

  HIST = BankHistory.new('./testhist.csv')

  def test_find_totals_with_description
    assert_equal(-21.0,
                  HIST.sum_with_requirements(description: "location 1"))
    assert_equal(-67.0,
                  HIST.sum_with_requirements(description: "location 2"))
  end

  def test_sum_transactions_in_date_range
    assert_equal(-61.0,
                  HIST.sum_with_requirements(start_date: "1/1/2014"))
    assert_equal(-27.0,
                  HIST.sum_with_requirements(end_date: "12/15/2013"))
    assert_equal(-64.0,
                  HIST.sum_with_requirements(start_date: "12/1/2013",
                                             end_date: "1/2/2014"))
  end

  def test_sum_with_description_and_range
    assert_equal(-12.0,
                  HIST.sum_with_requirements(start_date: "12/1/2013",
                                             end_date: "12/15/2013",
                                             description: "location 1"))
  end

  def test_find_specified_amount
    assert_equal(1,
                 HIST.get_with_requirements(amount: -12.0).length)
  end

  def test_find_with_multiple_descriptions
    assert_equal(4, 
                 HIST.get_with_requirements(description: ["1", "2"]).length)
  end

  def test_find_with_mutliple_amounts
    assert_equal(2, 
             HIST.get_with_requirements(amount: [-12.0,-15.00]).length)
  end

end