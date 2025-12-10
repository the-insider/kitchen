class Menu < ApplicationRecord
  belongs_to :restaurant

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end

