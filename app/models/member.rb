class Member < ApplicationRecord
  has_many :glucose_levels, dependent: :destroy
end