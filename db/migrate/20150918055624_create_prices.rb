class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :name
      t.string :cost

      t.timestamps null: false
    end
    add_column :prices, :parentid, :integer, default: 0
  end
end
