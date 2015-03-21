class CreatePostinoSettings < ActiveRecord::Migration
  def change
    create_table :postino_settings do |t|
      t.text :config
      t.references :campaign, index: true

      t.timestamps null: false
    end
    add_foreign_key :postino_settings, :campaigns
  end
end
