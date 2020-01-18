class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |u|
      u.string :name
      u.string :username
      u.string :password_digest
      u.integer :points
    end

  end
end
