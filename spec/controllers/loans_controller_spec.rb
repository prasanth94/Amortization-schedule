require 'rails_helper'

RSpec.describe LoansController, type: :controller do

	describe "#index" do
    before do
      get :index
    end
       
    it "renders the 'index' template" do
      expect(response).to render_template :index
    end
  end

  describe "#new" do
    before do
      get :new
    end
       
    it "renders the 'index' template" do
      expect(response).to render_template :new
    end
  end

  describe "#create" do
   
    let(:params_for_create) { attributes_for(:loan) }

    it "redirects to the amortization_schedule page on successful Loan creation" do
      post :create, { loan: params_for_create }
      loan = Loan.last
      expect(response).to redirect_to generate_amortization_schedule_loan_path(loan)
    end

    it "creates a new loan" do
      expect {
        post :create, { loan: params_for_create }
        }.to change(Loan, :count).by(1)
    end
  end	
end