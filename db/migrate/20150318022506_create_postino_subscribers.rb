class CreateChaskiqSubscribers < ActiveRecord::Migration
  def change
    create_table :chaskiq_subscribers do |t|
      t.string :name
      t.string :email
      t.string :state
      t.string :last_name

      t.references :list, index: true

      t.timestamps null: false
    end
    add_foreign_key :chaskiq_subscribers, :lists
  end
end
