class CreateChaskiqTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :chaskiq_templates do |t|
      t.string :name
      t.text :body
      t.text :html_content
      t.string :screenshot

      t.timestamps null: false
    end
  end
end
