class DecryptService
    include ActiveModel::Validations
    attr_accessor :encrypted_message, :correspondences, :decrypted_message, :decrypt
    validates :encrypted_message, presence: true, format: { without: /\d/, message: "no puede contener números" }

    def initialize(decrypt:)
        @decrypt = decrypt
        @encrypted_message = @decrypt.enc_message.downcase
        @correspondences = set_correspondences
        @decrypted_message = ""
    end

    def call!
        make_equation
    end

    def make_equation
        @correspondences.each do |hash|
            param1, param2, param3, param4 = hash.keys[0], hash.values[0], hash.keys[1], hash.values[1]
            puts ("param1 = #{param1} param2 = #{param2} param3 = #{param3} param4 = #{param4}")
            value1, value2, value3, value4 = get_letter_index(param1), get_letter_index(param2), get_letter_index(param3), get_letter_index(param4)

            begin
                a,b = solve_system(value1, value2, value3, value4)
                puts "a = #{a} b = #{b}"
                decrypt_mesage(a,b,hash)
            rescue Exception => e
                DecryptTry.create(decrypt_id: decrypt.id, error_log: e.message.to_s, correspondence: hash, a: a, b: b)
                puts e
            end
        end
    end

    def decrypt_mesage(a,b,hash)
        decrypted_message = []
        for i in 0..encrypted_message.length-1
            if encrypted_message[i].blank?
                next
            end
            n = alphabet.count
            a_inv = inverse(a, n)
            c = get_letter_index(encrypted_message[i])
            index = (c - b) * a_inv % n
            letter = get_letter_by_index(index)
            decrypted_message << letter
        end
        DecryptTry.create(decrypt_id: decrypt.id, decrypted_message: decrypted_message.join(""), correspondence: hash.to_s, a: a, b: b)
    end


    def solve_system(value1, value2, value3, value4)
        b = value3
        a = ((value1-b)* inverse(value2,27))%27
        [a, b]
    end

    def set_correspondences
        mfc = most_frequent_chars
        mal = most_appeared_letters
        @correspondences =[
            {mfc.first => mal.first, mfc.second => mal.second},
            {mfc.second => mal.first, mfc.first => mal.second},
        ]
    end

    def character_frequency
        frequency = Hash.new(0)
        encrypted_message.each_char do |char|
          frequency[char] += 1 unless char == " "
        end
        frequency = frequency.sort_by { |k, v| -v }.to_h
        frequency
    end

    #private

    def inverse(a, m=27)
        raise "NO INVERSE - #{a} and #{m} not coprime" unless a.gcd(m) == 1
        return m if m == 1
        m0, inv, x0 = m, 1, 0
        while a > 1
            inv -= (a / m) * x0
            a, m = m, a % m
            inv, x0 = x0, inv
        end
        inv += m0 if inv < 0
        inv
    end

    def most_frequent_chars
        character_frequency.keys[0..1]
    end

    def most_appeared_letters
        letters = ["e", "a", "o", "s"]
        letters
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
