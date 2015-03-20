class CreatePostinoMetrics < ActiveRecord::Migration
  def change
    create_table :postino_metrics do |t|
      t.references :trackable,  polymorphic: true, index: true, null: false
      t.references :campaign, index: true
      t.string :action
      t.string :host
      t.string :data
      t.timestamps null: false
    end
    add_foreign_key :postino_metrics, :trackables
  end
end
