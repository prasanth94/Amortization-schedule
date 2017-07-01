module EqualPaymentsAmortizationScheduleCreator
  include DifferentFirstPaymentAmortizationScheduleCreator

  def equal_payments_amortization_schedule(principal_amount:, interest_rate:, term:, request_date:)
    @term = term
    @request_date = request_date
    @principal_amount = principal_amount
    @interest_per_period = interest_per_period(interest_rate)
    @monthly_payment = emi(principal_amount, term)
    amortization_schedule
  end

  private

  def amortization_schedule
    compute_amortization_schedule_for_first_month
    compute_amortization_schedule_for_rest_of_months
    compute_amortization_schedule unless ending_balance_is_near_zero?
    adjust_last_payment
    @amortization_schedule
  end

  def compute_amortization_schedule
    until ending_balance_is_near_zero?
      @monthly_payment -= 0.001
      compute_amortization_schedule_for_first_month
      compute_amortization_schedule_for_rest_of_months
    end
  end

  def adjust_last_payment
    @amortization_schedule.last[:principal_component] = @amortization_schedule.last[:beginning_balance]
    @amortization_schedule.last[:monthly_payment] += @amortization_schedule.last[:ending_balance]
    @amortization_schedule.last[:ending_balance] = 0
  end

  def ending_balance_is_near_zero?
    @amortization_schedule.last[:ending_balance].between?(-0.01, 0.01)
  end

  def compute_amortization_schedule_for_first_month
    @amortization_schedule = []
    number_of_days_for_interest_in_first_installment = 31 - @request_date.day
    interest_for_first_installment = @interest_per_period * (number_of_days_for_interest_in_first_installment.to_f / 30)
    interest_component = interest_component(@principal_amount, interest_for_first_installment)
    due_date = next_due_date(@request_date)
    principal_component = principal_component(@monthly_payment, interest_component)
    ending_balance = ending_balance(@principal_amount, principal_component)
    @amortization_schedule.push(due_date: due_date, beginning_balance: @principal_amount, ending_balance: ending_balance,
                                interest_component: interest_component, principal_component: principal_component,
                                monthly_payment: @monthly_payment)
  end

  def compute_amortization_schedule_for_rest_of_months
    (@term - 1).times do
      beginning_balance = @amortization_schedule.last[:ending_balance]
      interest_component = interest_component(beginning_balance, @interest_per_period)
      principal_component = principal_component(@monthly_payment, interest_component)
      ending_balance = ending_balance(beginning_balance, principal_component)
      due_date = next_due_date(@amortization_schedule.last[:due_date])
      @amortization_schedule.push(due_date: due_date, beginning_balance: beginning_balance, ending_balance: ending_balance,
                                  interest_component: interest_component, principal_component: principal_component,
                                  monthly_payment: @monthly_payment)
    end
  end

  def interest_component(beginning_balance, interest_component)
    beginning_balance * interest_component
  end

  def principal_component(payment_amount, interest_component)
    payment_amount - interest_component
  end

  def ending_balance(beginning_balance, principal_component)
    beginning_balance - principal_component
  end

  def interest_per_period(interest_rate)
    interest_rate / (100 * 12)
  end

  def next_due_date(due_date)
    due_date.next_month.at_beginning_of_month
  end
end
