require 'rails_helper'

RSpec.describe LoansController, type: :controller do
  describe '#index' do
    it "renders the 'index' template" do
      response = get :index
      expect(response).to render_template :index
    end

    it 'sets array of loans' do
      loan = create(:loan)
      get :index
      expect(assigns(:loans)).to include(loan)
      expect(assigns(:loans).count).to eq 1
    end
  end

  describe '#new' do
    before do
      get :new
    end

    it "renders the 'index' template" do
      expect(response).to render_template :new
    end

    it 'sets a new loan' do
      expect(assigns(:loan)).to be_a_new(Loan)
    end
  end

  describe '#create' do
    context 'with valid attributes' do
      let(:params_for_create) { attributes_for(:loan) }

      it 'creates a new loan' do
        expect do
          post :create, loan: params_for_create
        end.to change(Loan, :count).by(1)
      end

      it 'redirects to the amortization_schedule page on successful Loan creation' do
        post :create, loan: params_for_create
        loan = Loan.last
        expect(response).to redirect_to generate_amortization_schedule_loan_path(loan)
      end
    end

    context 'with invalid attributes' do
      let(:params_for_create) { attributes_for(:loan, interest_rate: 23.333333) }

      it 'redirects to the amortization_schedule page on successful Loan creation' do
        post :create, loan: params_for_create
        expect(response).to render_template :new
      end

      it 'creates a new loan' do
        expect do
          post :create, loan: params_for_create
        end.to_not change(Loan, :count)
      end
    end
  end

  describe '#generate_amortization_schedule' do
    let(:loan) { create(:loan) }

    it 'should call amortization schedule method' do
      expect_any_instance_of(Loan).to receive(:amortization_schedule) { 'something' }
      get :generate_amortization_schedule, id: loan.id
      expect(assigns(:amortization_schedule)).to eq('something')
    end

    it "renders the 'index' template" do
      response = get :generate_amortization_schedule, id: loan.id
      expect(response).to render_template :generate_amortization_schedule
    end
  end
end
