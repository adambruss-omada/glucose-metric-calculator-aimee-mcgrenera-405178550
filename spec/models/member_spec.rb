require 'rails_helper'

RSpec.describe Member do
  it 'has a valid factory' do
    expect(create(:member)).to be_valid
  end

  it 'has many glucose levels' do
    member = create(:member)
    glucose_level1 = create(:glucose_level, member: member)
    glucose_level2 = create(:glucose_level, member: member)

    expect(member.glucose_levels).to include(glucose_level1, glucose_level2)
  end
end
