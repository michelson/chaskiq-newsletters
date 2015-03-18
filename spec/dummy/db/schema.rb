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

ActiveRecord::Schema.define(version: 20150318040633) do

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

  create_table "postino_campaigns", force: :cascade do |t|
    t.string   "subject"
    t.string   "from_name"
    t.string   "from_email"
    t.string   "reply_email"
    t.text     "plain_content"
    t.text     "html_content"
    t.string   "query_string"
    t.datetime "scheduled_at"
    t.string   "timezone"
    t.string   "state"
    t.integer  "recipients_count"
    t.boolean  "sent"
    t.integer  "opens_count"
    t.integer  "clicks_count"
    t.integer  "parent_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "list_id"
  end

  add_index "postino_campaigns", ["list_id"], name: "index_postino_campaigns_on_list_id"
  add_index "postino_campaigns", ["parent_id"], name: "index_postino_campaigns_on_parent_id"

  create_table "postino_lists", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.integer  "unsubscribe_count"
    t.integer  "bounced"
    t.integer  "active_count"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "postino_subscribers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "state"
    t.integer  "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "postino_subscribers", ["list_id"], name: "index_postino_subscribers_on_list_id"

  create_table "postino_templates", force: :cascade do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
