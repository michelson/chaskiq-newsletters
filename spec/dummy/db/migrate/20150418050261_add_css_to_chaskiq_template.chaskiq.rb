# This migration comes from chaskiq (originally 20150331025829)
class AddCssToChaskiqTemplate < ActiveRecord::Migration
  def change
    add_column :chaskiq_templates, :css, :text
  end
end
