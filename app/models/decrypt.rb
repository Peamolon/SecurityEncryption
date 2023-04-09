class Decrypt < ApplicationRecord
  belongs_to :user
  validates :enc_message, format: { without: /\d/, message: "No puede contener numeros" }
  has_many :decrypt_tries
end
