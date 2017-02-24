class CreateCoins < ActiveRecord::Migration[5.0]
  def change
    create_table :coins do |t|
      t.integer :quantity
      t.integer :denomination

      t.timestamps
    end
  end
end
