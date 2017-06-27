require 'rails_helper'

RSpec.describe 'routes for Loans', type: :routing do
  it { expect(post('/loans')).to route_to('loans#create') }

  it { expect(get('loans/1/generate_amortization_schedule')).to route_to('loans#generate_amortization_schedule', id: '1') }

  it { expect(get('/loans/new/')).to route_to('loans#new') }

  it { expect(get('/loans/')).to route_to('loans#index') }

  it { expect(get('/')).to route_to('loans#new') }
end
