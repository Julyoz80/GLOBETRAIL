class Travel < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy
  has_one_attached :photo
  validates :country, :number_of_travellers, :budget, :trip_duration, presence: true
end
