module DifferentFirstPaymentAmortizationScheduleCreator
  def different_first_payment_amortization_schedule(principal_amount:, interest_rate:, term:, request_date:)
    @amortization_schedule_hash = []
    @interest_per_period = interest_rate / (100 * 12)
    @beginning_balance = principal_amount
    @due_date = request_date
    @monthly_payment = emi(principal_amount,term)
    calculate_first_month_amortization_schedule_with_different_first_payment
    calculate_amortization_schedule_for_rest_of_months(term)
    @amortization_schedule_hash
  end

  private

  def calculate_first_month_amortization_schedule_with_different_first_payment
    number_of_days_for_interest_in_first_installment = 31 - @due_date.day
    interest_for_first_installment = @interest_per_period * (number_of_days_for_interest_in_first_installment.to_f / 30)
    @interest_component = @beginning_balance * interest_for_first_installment
    next_due_date
    first_month_payment_amount = @monthly_payment - ((@beginning_balance * @interest_per_period) - @interest_component)
    @principal_component = first_month_payment_amount - @interest_component
    @ending_balance = @beginning_balance - @principal_component
    push_to_amortization_schedule_hash(first_month_payment_amount)
  end

  def calculate_amortization_schedule_for_rest_of_months(term)
    (term - 1).times do
      @beginning_balance -= @principal_component
      @interest_component = @beginning_balance * @interest_per_period
      @principal_component = @monthly_payment - @interest_component
      @ending_balance = @beginning_balance - @principal_component
      next_due_date
      push_to_amortization_schedule_hash(@monthly_payment)
    end
  end

  def push_to_amortization_schedule_hash(monthly_payment)
    @amortization_schedule_hash.push(due_date: @due_date, beginning_balance: @beginning_balance, ending_balance: @ending_balance,
                                     interest_component: @interest_component, principal_component: @principal_component,
                                     monthly_payment: monthly_payment)
  end

  def emi(principal_amount,term)
    ((principal_amount * @interest_per_period) * ((@interest_per_period + 1)**term)) /
      (((@interest_per_period + 1)**term) - 1)
  end

  def next_due_date
    @due_date = @due_date.next_month.at_beginning_of_month
  end
end
