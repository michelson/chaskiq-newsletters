class AddReferenceToCampaign < ActiveRecord::Migration
  def change
    add_reference :postino_campaigns, :list, index: true
    #add_foreign_key :campaigns, :lists
  end
end
