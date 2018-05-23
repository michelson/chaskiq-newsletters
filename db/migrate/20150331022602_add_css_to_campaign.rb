class AddCssToCampaign < ActiveRecord::Migration[4.2]
  def change
    add_column :chaskiq_campaigns, :css, :text
  end
end
