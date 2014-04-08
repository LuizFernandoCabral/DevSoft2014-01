require_relative 'checking_account'

class StudentAccount < CheckingAccount

  def initialize
    @monthly_fee    = 0

    @@accounts << self
  end

  def withdraw(amount)
    if @balance>= amount
      @balance -= amount
      log_transaction('Withdrawal', amount)
    else
      puts ("Not enough money in account")
  end
end