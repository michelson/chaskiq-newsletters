class CreateChaskiqAttachments < ActiveRecord::Migration[4.2]
  def change
    create_table :chaskiq_attachments do |t|
      t.string :image
      t.string :content_type
      t.integer :size
      t.string :name
      t.references :campaign, index: true

      t.timestamps null: false
    end
    #add_foreign_key :chaskiq_attachments, :chaskiq_campaigns
  end
end
