# This migration comes from chaskiq (originally 20150331022602)
class AddCssToCampaign < ActiveRecord::Migration
  def change
    add_column :chaskiq_campaigns, :css, :text
  end
end
