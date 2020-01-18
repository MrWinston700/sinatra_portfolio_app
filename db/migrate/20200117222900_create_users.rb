class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |u|
      t.string :name
      t.string :username
      t.string :password_digest
      t.integer :points
    end

  end
end
