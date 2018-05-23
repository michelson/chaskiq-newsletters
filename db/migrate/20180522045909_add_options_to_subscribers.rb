class AddOptionsToLists < ActiveRecord::Migration[5.1]
  def change
    add_column :chaskiq_subscribers, :options, :text
  end
end
