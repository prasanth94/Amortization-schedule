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

  describe "#generate_amortization_schedule" do
    
    let(:params_for_create) { attributes_for(:loan) }

    it "redirects to the amortization_schedule page on successful Loan creation" do
      post :generate_amortization_schedule, { loan: params_for_create }
      
      expect(response).to render_template :generate_amortization_schedule
    end

    it "creates a new loan" do
      expect {
        post :generate_amortization_schedule, { loan: params_for_create }
        }.to change(Loan, :count).by(1)
    end
    
  end	



end