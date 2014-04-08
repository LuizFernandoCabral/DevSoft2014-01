require_relative 'bank_account'

class SalaryAccount < BankAccount

  def initialize
    @monthly_fee    = 0.5*MONTHLY_FEE

    @@accounts << self
  end

  def deposit(amount)
    @balance += amount
    log_transaction('Deposit', amount)
  end

  def withdraw(amount)
    @balance -= amount
    log_transaction('Withdrawal', amount)
  end

