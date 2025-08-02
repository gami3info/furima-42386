class RenameColumnsInItems < ActiveRecord::Migration[7.1]
  def change
    rename_column :items, :item_name, :name
    rename_column :items, :explanation, :description
    rename_column :items, :status_id, :condition_id
    rename_column :items, :postage_id, :shipping_fee_burden_id
    rename_column :items, :shipping_date_id, :shipping_day_id
  end
end
