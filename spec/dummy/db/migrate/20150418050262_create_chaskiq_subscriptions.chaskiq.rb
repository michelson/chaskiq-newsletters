# This migration comes from chaskiq (originally 20150402201729)
class CreateChaskiqSubscriptions < ActiveRecord::Migration
  def change
    create_table :chaskiq_subscriptions do |t|
      t.string :state
      t.references :campaign, index: true
      t.references :subscriber, index: true
      t.references :list, index: true
      t.timestamps null: false
    end
    #add_foreign_key :chaskiq_subscriptions, :campaigns
    #add_foreign_key :chaskiq_subscriptions, :subscribers
  end
end
