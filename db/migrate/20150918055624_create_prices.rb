class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :name
      t.string :cost
      t.integer :parentid, default: 0

      t.timestamps null: false
    end
  end
end
