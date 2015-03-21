# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150321210329) do

  create_table "postino_attachments", force: :cascade do |t|
    t.string   "image"
    t.string   "content_type"
    t.integer  "size"
    t.string   "name"
    t.integer  "campaign_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "postino_attachments", ["campaign_id"], name: "index_postino_attachments_on_campaign_id"

  create_table "postino_campaign_templates", force: :cascade do |t|
    t.integer  "template_id"
    t.integer  "campaign_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "postino_campaign_templates", ["campaign_id"], name: "index_postino_campaign_templates_on_campaign_id"
  add_index "postino_campaign_templates", ["template_id"], name: "index_postino_campaign_templates_on_template_id"

# Could not dump table "postino_campaigns" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "postino_lists", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.integer  "unsubscribe_count"
    t.integer  "bounced"
    t.integer  "active_count"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "postino_metrics", force: :cascade do |t|
    t.integer  "trackable_id",   null: false
    t.string   "trackable_type", null: false
    t.integer  "campaign_id"
    t.string   "action"
    t.string   "host"
    t.string   "data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "postino_metrics", ["campaign_id"], name: "index_postino_metrics_on_campaign_id"
  add_index "postino_metrics", ["trackable_type", "trackable_id"], name: "index_postino_metrics_on_trackable_type_and_trackable_id"

  create_table "postino_settings", force: :cascade do |t|
    t.text     "config"
    t.integer  "campaign_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "postino_settings", ["campaign_id"], name: "index_postino_settings_on_campaign_id"

  create_table "postino_subscribers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "state"
    t.integer  "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "last_name"
  end

  add_index "postino_subscribers", ["list_id"], name: "index_postino_subscribers_on_list_id"

  create_table "postino_templates", force: :cascade do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "html_content"
    t.string   "screenshot"
  end

end
