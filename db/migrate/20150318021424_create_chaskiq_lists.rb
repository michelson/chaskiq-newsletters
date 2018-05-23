class CreateChaskiqLists < ActiveRecord::Migration[4.2]
  def change
    create_table :chaskiq_lists do |t|
      t.string :name
      t.string :state
      t.integer :unsubscribe_count
      t.integer :bounced
      t.integer :active_count

      t.timestamps null: false
    end
  end
end
