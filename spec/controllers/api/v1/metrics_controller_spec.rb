require 'rails_helper'

RSpec.describe Api::V1::MetricsController, type: :controller do
  let(:member) { create(:member) }
  let(:glucose_calculator) { instance_double(GlucoseMetrics::Calculator, metrics_for: {}, changes: {}) }

  before do
    allow(GlucoseMetrics::Calculator).to receive(:new).with(member: member).and_return(glucose_calculator)
  end

  describe 'GET #show' do
    it 'returns metrics for the member' do
      get :show, params: { member_id: member.id, period: 'last_7_days' }
      
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include(
        'member_id' => member.id,
        'period' => 'last_7_days',
        'metrics' => {}
      )
    end

    it 'handles member not found' do
      expect {
        get :show, params: { member_id: -1 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns error for invalid period' do
      get :show, params: { member_id: member.id, period: 'invalid_period' }
        
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to include('error' => 'Invalid period')
    end
  end
end