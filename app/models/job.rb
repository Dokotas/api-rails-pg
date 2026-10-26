class Job < ApplicationRecord
  belongs_to :company
  has_many :applies, dependent: :destroy
  has_many :geeks, through: :applies

  validates :name, :place, presence: true, length: { maximum: 100 }
  validates :company_id, presence: true, numericality: { only_integer: true }

  scope :by_name,  ->(v) { where('name ILIKE ?', "%#{v}%") if v.present? }
  scope :by_place, ->(v) { where('place ILIKE ?', "%#{v}%") if v.present? }
end
