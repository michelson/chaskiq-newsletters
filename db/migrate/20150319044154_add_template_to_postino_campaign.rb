class AddTemplateToPostinoCampaign < ActiveRecord::Migration
  def change
    add_reference :postino_campaigns, :template, index: true
    add_foreign_key :postino_campaigns, :templates
  end
end
