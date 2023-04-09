class CreateDecrypts < ActiveRecord::Migration[7.0]
  def change
    create_table :decrypts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :enc_message

      t.timestamps
    end
  end
end
