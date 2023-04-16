class DecryptTry < ApplicationRecord
  belongs_to :decryption, class_name: 'Decrypt', foreign_key: 'decrypt_id'

  def self.filter_attributes
    super - ['decrypt_id']
  end
end
