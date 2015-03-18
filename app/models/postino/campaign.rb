# string   "subject"
# string   "from_name"
# string   "from_email"
# string   "reply_email"
# text     "plain_content"
# text     "html_content"
# string   "query_string"
# datetime "scheduled_at"
# string   "timezone"
# string   "state"
# integer  "recipients_count"
# boolean  "sent"
# integer  "opens_count"
# integer  "clicks_count"
# integer  "parent_id"
# datetime "created_at",       null: false
# datetime "updated_at",       null: false


module Postino
  class Campaign < ActiveRecord::Base
    belongs_to :parent, class_name: "Postino::Campaign"
    has_many :attachments
    belongs_to :list
    has_one :campaign_template
    has_one :template, through: :campaign_template

    validates :subject, presence: true
    validates :from_name, presence: true
    validates :from_email, presence: true

    validates :plain_content, presence: true
    validates :html_content, presence: true



  end
end
