class CreatePostinoMetrics < ActiveRecord::Migration
  def change
    create_table :postino_metrics do |t|
      t.references :subject, index: true
      t.references :campaign, index: true
      t.string :host
      t.string :action
      t.string :data

      t.timestamps null: false
    end
    add_foreign_key :postino_metrics, :subjects
    add_foreign_key :postino_metrics, :campaigns
  end
end
