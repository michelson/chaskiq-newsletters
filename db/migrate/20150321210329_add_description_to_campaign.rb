class AddDescriptionToCampaign < ActiveRecord::Migration
  def change
    add_column :postino_campaigns, :description, :text
    add_column :postino_campaigns, :logo, :strings
  end
end
