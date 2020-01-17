class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |i|
      i.string :name
      i.string :description
      i.integer :cost
      i.string :status
    end
  end
end
