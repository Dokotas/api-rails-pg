class Geek < ApplicationRecord
  has_many :applies, dependent: :destroy
  has_many :jobs, through: :applies

  validates :name, :stack, presence: true, length: { maximum: 100 }

  scope :by_name,  ->(v) { where('geeks.name ILIKE ?', "%#{v}%") if v.present? }
  scope :by_stack, ->(v) { where('stack ILIKE ?', "%#{v}%") if v.present? }
end
