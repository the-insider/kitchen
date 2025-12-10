class AddDietaryTypeToMenus < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :dietary_type, :integer, default: 0, null: false
  end
end

