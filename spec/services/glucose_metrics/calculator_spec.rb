require 'rails_helper'

RSpec.describe GlucoseMetrics::Calculator do
  let(:member) { create(:member) }
  let(:calculator) { described_class.new(member: member) }
  
  describe '#metrics_for' do
    context 'when there are no glucose readings' do
      it 'returns an empty hash' do
        expect(calculator.metrics_for(:this_week)).to eq({})
      end
    end
    
    context 'when there are glucose readings' do
      before do
        create(:glucose_level, member: member, value: 100, tested_at: 1.day.ago)
      end
      
      it 'calculates metrics correctly for this week' do
        metrics = calculator.metrics_for(:last_7_days)
        expect(metrics[:average]).to eq(100.0)
        expect(metrics[:above_range]).to eq(0.0)
        expect(metrics[:below_range]).to eq(0.0)
        expect(metrics[:count]).to eq(1)
      end

      it 'calculates metrics correctly for the previous week' do
        create(:glucose_level, member: member, value: 200, tested_at: 8.days.ago)
        metrics = calculator.metrics_for(:previous_week)
        expect(metrics[:average]).to eq(200.0)
        expect(metrics[:above_range]).to eq(100.0)
        expect(metrics[:below_range]).to eq(0.0)
        expect(metrics[:count]).to eq(1)
      end

      it 'calculates metrics correctly for this month' do
        create(:glucose_level, member: member, value: 150, tested_at: 5.days.ago)
        metrics = calculator.metrics_for(:this_month)
        expect(metrics[:average]).to eq(125.0)
        expect(metrics[:above_range]).to eq(0.0)
        expect(metrics[:below_range]).to eq(0.0)
        expect(metrics[:count]).to eq(2)
      end

      it 'calculates metrics correctly for last month' do
        create(:glucose_level, member: member, value: 60, tested_at: 35.days.ago)
        metrics = calculator.metrics_for(:last_month)
        expect(metrics[:average]).to eq(60.0)
        expect(metrics[:above_range]).to eq(0.0)
        expect(metrics[:below_range]).to eq(100.0)
        expect(metrics[:count]).to eq(1)
      end
    end
  end
end