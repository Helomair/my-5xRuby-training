class Task < ApplicationRecord
	validates :title, presence: true
	validates :status, presence: true
	belongs_to :user
end
