class AddCssToChaskiqTemplate < ActiveRecord::Migration
  def change
    add_column :chaskiq_templates, :css, :text
  end
end
