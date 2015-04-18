# This migration comes from chaskiq (originally 20150321205815)
class CreateChaskiqSettings < ActiveRecord::Migration
  def change
    create_table :chaskiq_settings do |t|
      t.text :config
      t.references :campaign, index: true

      t.timestamps null: false
    end
    #add_foreign_key :chaskiq_settings, :campaign
  end
end
