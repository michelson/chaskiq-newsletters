class AddCssToCampaign < ActiveRecord::Migration
  def change
    add_column :chaskiq_campaigns, :css, :text
  end
end
