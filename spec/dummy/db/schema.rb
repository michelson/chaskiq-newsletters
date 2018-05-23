# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150404090650) do

  create_table "chaskiq_attachments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "image"
    t.string "content_type"
    t.integer "size"
    t.string "name"
    t.integer "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_chaskiq_attachments_on_campaign_id"
  end

  create_table "chaskiq_campaigns", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "subject"
    t.string "from_name"
    t.string "from_email"
    t.string "reply_email"
    t.text "plain_content"
    t.text "html_content"
    t.text "premailer"
    t.text "description"
    t.string "logo"
    t.string "name"
    t.string "query_string"
    t.datetime "scheduled_at"
    t.string "timezone"
    t.string "state"
    t.integer "recipients_count"
    t.boolean "sent"
    t.integer "opens_count"
    t.integer "clicks_count"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "list_id"
    t.integer "template_id"
    t.text "css"
    t.index ["list_id"], name: "index_chaskiq_campaigns_on_list_id"
    t.index ["parent_id"], name: "index_chaskiq_campaigns_on_parent_id"
    t.index ["template_id"], name: "index_chaskiq_campaigns_on_template_id"
  end

  create_table "chaskiq_lists", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.string "state"
    t.integer "unsubscribe_count"
    t.integer "bounced"
    t.integer "active_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chaskiq_metrics", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "trackable_id", null: false
    t.string "trackable_type", null: false
    t.integer "campaign_id"
    t.string "action"
    t.string "host"
    t.string "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_chaskiq_metrics_on_campaign_id"
    t.index ["trackable_type", "trackable_id"], name: "index_chaskiq_metrics_on_trackable_type_and_trackable_id"
  end

  create_table "chaskiq_settings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.text "config"
    t.integer "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_chaskiq_settings_on_campaign_id"
  end

  create_table "chaskiq_subscribers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.string "email"
    t.string "state"
    t.string "last_name"
    t.integer "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_chaskiq_subscribers_on_list_id"
  end

  create_table "chaskiq_subscriptions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "state"
    t.integer "campaign_id"
    t.integer "subscriber_id"
    t.integer "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_chaskiq_subscriptions_on_campaign_id"
    t.index ["list_id"], name: "index_chaskiq_subscriptions_on_list_id"
    t.index ["subscriber_id"], name: "index_chaskiq_subscriptions_on_subscriber_id"
  end

  create_table "chaskiq_templates", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.text "body"
    t.text "html_content"
    t.string "screenshot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "css"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
