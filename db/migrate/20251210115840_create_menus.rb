class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus, id: :uuid do |t|
      t.references :restaurant, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :category

      t.timestamps
    end
  end
end

