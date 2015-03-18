class AddHtmlContentToTemplate < ActiveRecord::Migration
  def change
    add_column :postino_templates, :html_content, :text
    add_column :postino_templates, :screenshot, :string
  end
end
