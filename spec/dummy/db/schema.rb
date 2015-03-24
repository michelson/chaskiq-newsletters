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

ActiveRecord::Schema.define(version: 20150321205815) do

  create_table "chaskiq_attachments", force: :cascade do |t|
    t.string   "image",        limit: 255
    t.string   "content_type", limit: 255
    t.integer  "size",         limit: 4
    t.string   "name",         limit: 255
    t.integer  "campaign_id",  limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "chaskiq_attachments", ["campaign_id"], name: "index_chaskiq_attachments_on_campaign_id", using: :btree

  create_table "chaskiq_campaigns", force: :cascade do |t|
    t.string   "subject",          limit: 255
    t.string   "from_name",        limit: 255
    t.string   "from_email",       limit: 255
    t.string   "reply_email",      limit: 255
    t.text     "plain_content",    limit: 65535
    t.text     "html_content",     limit: 65535
    t.text     "premailer",        limit: 65535
    t.text     "description",      limit: 65535
    t.string   "logo",             limit: 255
    t.string   "name",             limit: 255
    t.string   "query_string",     limit: 255
    t.datetime "scheduled_at"
    t.string   "timezone",         limit: 255
    t.string   "state",            limit: 255
    t.integer  "recipients_count", limit: 4
    t.boolean  "sent",             limit: 1
    t.integer  "opens_count",      limit: 4
    t.integer  "clicks_count",     limit: 4
    t.integer  "parent_id",        limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "list_id",          limit: 4
    t.integer  "template_id",      limit: 4
  end

  add_index "chaskiq_campaigns", ["list_id"], name: "index_chaskiq_campaigns_on_list_id", using: :btree
  add_index "chaskiq_campaigns", ["parent_id"], name: "index_chaskiq_campaigns_on_parent_id", using: :btree
  add_index "chaskiq_campaigns", ["template_id"], name: "index_chaskiq_campaigns_on_template_id", using: :btree

  create_table "chaskiq_lists", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "state",             limit: 255
    t.integer  "unsubscribe_count", limit: 4
    t.integer  "bounced",           limit: 4
    t.integer  "active_count",      limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "chaskiq_metrics", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4,   null: false
    t.string   "trackable_type", limit: 255, null: false
    t.integer  "campaign_id",    limit: 4
    t.string   "action",         limit: 255
    t.string   "host",           limit: 255
    t.string   "data",           limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "chaskiq_metrics", ["campaign_id"], name: "index_chaskiq_metrics_on_campaign_id", using: :btree
  add_index "chaskiq_metrics", ["trackable_type", "trackable_id"], name: "index_chaskiq_metrics_on_trackable_type_and_trackable_id", using: :btree

  create_table "chaskiq_settings", force: :cascade do |t|
    t.text     "config",      limit: 65535
    t.integer  "campaign_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "chaskiq_settings", ["campaign_id"], name: "index_chaskiq_settings_on_campaign_id", using: :btree

  create_table "chaskiq_subscribers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "state",      limit: 255
    t.string   "last_name",  limit: 255
    t.integer  "list_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "chaskiq_subscribers", ["list_id"], name: "index_chaskiq_subscribers_on_list_id", using: :btree

  create_table "chaskiq_templates", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "body",         limit: 65535
    t.text     "html_content", limit: 65535
    t.string   "screenshot",   limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

end
