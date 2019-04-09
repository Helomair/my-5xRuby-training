class Task < ApplicationRecord
	validates :title, presence: true
	validates :status, presence: true
end
