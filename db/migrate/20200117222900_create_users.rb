class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |u|
      t.string :name
      t.integer :points
    end

  end
end
