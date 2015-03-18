class CreatePostinoCampaignTemplates < ActiveRecord::Migration
  def change
    create_table :postino_campaign_templates do |t|
      t.references :template, index: true
      t.references :campaign, index: true

      t.timestamps null: false
    end
    add_foreign_key :postino_campaign_templates, :templates
    add_foreign_key :postino_campaign_templates, :campaigns
  end
end
