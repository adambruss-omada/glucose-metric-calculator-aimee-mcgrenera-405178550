require 'rails_helper'

RSpec.describe GlucoseLevel do
  it 'belongs to a member' do
    member = create(:member)
    glucose_level = create(:glucose_level, member: member)
        
    expect(glucose_level.member).to eq(member)
  end
end
