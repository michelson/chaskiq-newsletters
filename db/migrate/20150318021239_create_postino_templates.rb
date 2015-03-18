class CreatePostinoTemplates < ActiveRecord::Migration
  def change
    create_table :postino_templates do |t|
      t.string :name
      t.text :body

      t.timestamps null: false
    end
  end
end
