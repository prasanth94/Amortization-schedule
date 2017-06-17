require 'rails_helper'

RSpec.describe Loan, type: :model do

  it { is_expected.to have_db_column(:loan_amount).of_type(:integer) }
  it { is_expected.to have_db_column(:interest_rate).of_type(:float) }
  it { is_expected.to have_db_column(:request_date).of_type(:date) }
  it { is_expected.to have_db_column(:term).of_type(:integer) }

 
  it { is_expected.to validate_presence_of :loan_amount }
  it { is_expected.to validate_presence_of :interest_rate }
  it { is_expected.to validate_presence_of :term }
  it { is_expected.to validate_presence_of :request_date }

  it { is_expected.to validate_numericality_of(:loan_amount).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:loan_amount).only_integer }
  it { is_expected.to validate_numericality_of(:term).only_integer }
  it { is_expected.to validate_numericality_of(:term).is_greater_than_or_equal_to(1) }
  it { is_expected.to validate_numericality_of(:interest_rate).is_greater_than(0) }

  describe "validatiion for the interest rate format" do
  	let(:loan) { build(:loan, interest_rate: 12.555) }
    it { is_expected.not_to allow_value(loan.interest_rate).for(:interest_rate) }
  end

  describe "validation for request time" do

  	let(:loan) { build(:loan)}
  	it "is valid with current date" do
  	  expect(loan).to be_valid
  	end

  	it "is valid with future date" do
      loan.request_date = "2100-06-25"
  	  expect(loan).not_to be_valid
  	end

  end
end
	