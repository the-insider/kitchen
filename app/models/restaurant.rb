class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :location, presence: true
end

