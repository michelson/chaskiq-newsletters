class CreatePostinoCampaignAttachments < ActiveRecord::Migration
  def change
    create_table :postino_campaign_attachments do |t|
      t.string :image
      t.string :content_type
      t.integer :size
      t.string :name
      t.references :campaign, index: true

      t.timestamps null: false
    end
    add_foreign_key :postino_campaign_attachments, :campaigns
  end
end
