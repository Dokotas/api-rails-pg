class Company < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_many :applies, through: :jobs
  has_many :geeks, -> { distinct }, through: :applies

  validates :name, presence: true, length: { maximum: 100 }
  validates :location, presence: true, length: { maximum: 100 }
  validates_associated :jobs

  scope :by_name,     ->(v) { where('name ILIKE ?', "%#{v}%") if v.present? }
  scope :by_location, ->(v) { where('location ILIKE ?', "%#{v}%") if v.present? }

  scope :active, -> { where(deleted: false) }

  def delete_company
    update(deleted: true)
  end
end
