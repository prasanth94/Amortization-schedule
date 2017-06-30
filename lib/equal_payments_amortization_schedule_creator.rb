module EqualPaymentsAmortizationScheduleCreator
  def equal_payments_amortization_schedule(principal_amount:, interest_rate:, term:, request_date:)
    @interest_per_period = interest_rate / (100 * 12)
    initialize_amortization_schedule_variables(principal_amount,request_date)
    @monthly_payment = emi(principal_amount, term)

    calculate_first_month_amortization_schedule_with_equal_payment
    calculate_amortization_schedule_for_rest_of_the_months_with_equal_payments(term)

    until check_ending_balance_is_near_zero?
      @monthly_payment -= 0.001
      initialize_amortization_schedule_variables(principal_amount,request_date)
      calculate_first_month_amortization_schedule_with_equal_payment
      calculate_amortization_schedule_for_rest_of_the_months_with_equal_payments(term)
    end

    adjustments_in_last_payment_in_amortization_schedule
    @amortization_schedule_hash
  end

  private

  def initialize_amortization_schedule_variables(principal_amount,request_date)
    @amortization_schedule_hash = []
    @beginning_balance = principal_amount
    @due_date = request_date
  end

  def adjustments_in_last_payment_in_amortization_schedule
    @amortization_schedule_hash.last[:principal_component] = @amortization_schedule_hash.last[:beginning_balance]
    @amortization_schedule_hash.last[:monthly_payment] += @amortization_schedule_hash.last[:ending_balance]
    @amortization_schedule_hash.last[:ending_balance] = 0
  end

  def check_ending_balance_is_near_zero?
    @amortization_schedule_hash.last[:ending_balance].between?(-0.01, 0.01)
  end

  def calculate_first_month_amortization_schedule_with_equal_payment
    number_of_days_for_interest_in_first_installment = 31 - @due_date.day
    interest_for_first_installment = @interest_per_period * (number_of_days_for_interest_in_first_installment.to_f / 30)
    @interest_component = @beginning_balance * interest_for_first_installment
    next_due_date
    @principal_component = @monthly_payment - @interest_component
    @ending_balance = @beginning_balance - @principal_component
    push_to_amortization_schedule_hash_of_equal_payments
  end

  def calculate_amortization_schedule_for_rest_of_the_months_with_equal_payments(term)
    (term - 1).times do
      @beginning_balance -= @principal_component
      @interest_component = @beginning_balance * @interest_per_period
      @principal_component = @monthly_payment - @interest_component
      @ending_balance = @beginning_balance - @principal_component
      next_due_date
      push_to_amortization_schedule_hash_of_equal_payments
    end
  end

  def push_to_amortization_schedule_hash_of_equal_payments
    @amortization_schedule_hash.push(due_date: @due_date, beginning_balance: @beginning_balance, ending_balance: @ending_balance,
                                     interest_component: @interest_component, principal_component: @principal_component,
                                     monthly_payment: @monthly_payment)
  end

  def emi(principal_amount,term)
    ((principal_amount * @interest_per_period) * ((@interest_per_period + 1)**term)) /
      (((@interest_per_period + 1)**term) - 1)
  end

  def next_due_date
    @due_date = @due_date.next_month.at_beginning_of_month
  end
end