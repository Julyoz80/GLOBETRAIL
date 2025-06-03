class Travel < ApplicationRecord
  belongs_to :user

  validates :country, :number_of_travellers, :budget, :trip_duration, presence: true
end
