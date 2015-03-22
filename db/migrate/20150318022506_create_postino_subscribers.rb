class CreatePostinoSubscribers < ActiveRecord::Migration
  def change
    create_table :postino_subscribers do |t|
      t.string :name
      t.string :email
      t.string :state
      t.string :last_name

      t.references :list, index: true

      t.timestamps null: false
    end
    add_foreign_key :postino_subscribers, :lists
  end
end
