class Menu < ApplicationRecord
  belongs_to :restaurant

  enum :dietary_type, {
    veg: 0,
    non_veg: 1,
    vegan: 2
  }

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
