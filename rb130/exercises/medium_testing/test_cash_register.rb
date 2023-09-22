require 'minitest/autorun'
require_relative 'cash_register'
require_relative 'transaction'

class CashRegisterTests < Minitest::Test 

  def test_accept_money
    trans = Transaction.new(20)
    trans.amount_paid = 20 
    register = CashRegister.new(0)
    register.accept_money(trans)
   
    assert_equal(20, register.total_money)
  end

  def test_change
    register = CashRegister.new(100)

    transaction = Transaction.new(15)
    transaction.amount_paid = 20

    assert_equal(5, register.change(transaction))
  end

  def test_give_receipt
    item_cost = 20
    transaction = Transaction.new(item_cost)
    register = CashRegister.new(0)
    
    assert_output("You've paid $#{item_cost}.\n") do
      register.give_receipt(transaction)
    end
  end


end
