class Encryption < ApplicationRecord
  belongs_to :user
  validate :a_and_b_are_coprime
  validates :a, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :b, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 27 }
  validates :message, presence: true
  private

  def a_and_b_are_coprime
    errors.add(:base, "A must to be coprime of 27") unless coprime?(a, 27)
    errors.add(:base, "A y B must to be coprime") unless coprime?(a, b)
  end

  def coprime?(a, b)
      gcd(a, b) == 1
  end

  def gcd(a, b)
      return a if b == 0
      gcd(b, a % b)
  end
end
