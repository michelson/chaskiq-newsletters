class CreateChaskiqCampaigns < ActiveRecord::Migration
  def change
    create_table :chaskiq_campaigns do |t|
      t.string :subject
      t.string :from_name
      t.string :from_email
      t.string :reply_email
      t.text :plain_content
      t.text :html_content
      t.text :premailer
      t.text :description
      t.string :logo
      t.string :name
      t.string :query_string
      t.datetime :scheduled_at
      t.string :timezone
      t.string :state
      t.integer :recipients_count
      t.boolean :sent
      t.integer :opens_count
      t.integer :clicks_count
      t.references :parent, index: true

      t.timestamps null: false
    end
    add_reference :chaskiq_campaigns, :list, index: true
    add_reference :chaskiq_campaigns, :template, index: true
    #add_foreign_key :chaskiq_campaigns, :chaskiq_templates
    #add_foreign_key :chaskiq_campaigns, :parents
  end
end
