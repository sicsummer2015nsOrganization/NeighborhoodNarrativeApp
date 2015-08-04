class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :zipcode
      t.string :persona

      t.timestamps null: false
    end
  end
end
