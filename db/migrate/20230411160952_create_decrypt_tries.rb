class CreateDecryptTries < ActiveRecord::Migration[7.0]
  def change
    create_table :decrypt_tries do |t|
      t.references :decrypt, null: false, foreign_key: true
      t.string :decrypted_message
      t.string :error_log
      t.string :correspondence
      t.string :a
      t.string :b
      t.timestamps
    end
  end
end
