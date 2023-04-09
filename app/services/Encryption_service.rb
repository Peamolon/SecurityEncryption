class EncryptionService
  include ActiveModel::Validations
  attr_accessor :encryption, :a, :b, :message, :encrypted_message, :current_user_id
  validates :a, presence: true, numericality: { only_integer: true }
  validates :b, presence: true, numericality: { only_integer: true }
  validates :message, presence: true
  
  def initialize(encryption:)
    @encryption = encryption
    @a = @encryption.a
    @b = @encryption.b
    @message = @encryption.message
    @encrypted_message = []
    @current_user_id = @encryption.user_id
  end

  def call!
    if self.valid?
      prepare_text
      encrypt_message
    else
      self.errors.full_messages
    end
  end

  def encrypt_message
    n = alphabet.size
    for i in 0..message.length-1
      if message[i].blank?
        encrypted_message << " "
        next
      end
      puts message[i]
      index = get_letter_index(message[i])
      encrypt_index = encrypt_index(index, n)
      encrypt_letter = get_letter_by_index(encrypt_index)
      encrypted_message << encrypt_letter
    end
    encryption.update(encrypted_message: encrypted_message.join(""))
  end
  private 

  def prepare_text 
    @message = @message.gsub(/[[:punct:]]/, '')
    @message = @message.gsub(/[áéíóú]/, 'á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u')
  end

  def encrypt_index(index, n)
    puts "a = #{a} index = #{index} n = #{n} b=#{n}"
    (a * index + b) % n
  end

  def get_letter_index(letter)
    alphabet[letter.downcase]
  end

  def get_letter_by_index(index)
    alphabet.invert[index]
  end

  def alphabet
    Hash[("a".."z").to_a.insert(14, "ñ").each_with_index.map{|c, i| [c, i]}]
  end
end