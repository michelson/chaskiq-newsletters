class AddNameToPostinoCampaign < ActiveRecord::Migration
  def change
    add_column :postino_campaigns, :name, :string
  end
end
