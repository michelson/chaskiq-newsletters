class AddCssToChaskiqTemplate < ActiveRecord::Migration[4.2]
  def change
    add_column :chaskiq_templates, :css, :text
  end
end
