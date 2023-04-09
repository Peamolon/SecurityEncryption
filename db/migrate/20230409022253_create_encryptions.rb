class CreateEncryptions < ActiveRecord::Migration[7.0]
  def change
    create_table :encryptions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :a
      t.integer :b
      t.string :message
      t.string :encrypted_message

      t.timestamps
    end
  end
end
