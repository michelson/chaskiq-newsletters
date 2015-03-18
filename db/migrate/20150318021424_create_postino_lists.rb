class CreatePostinoLists < ActiveRecord::Migration
  def change
    create_table :postino_lists do |t|
      t.string :name
      t.string :state
      t.integer :unsubscribe_count
      t.integer :bounced
      t.integer :active_count

      t.timestamps null: false
    end
  end
end
