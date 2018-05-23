class CreateChaskiqMetrics < ActiveRecord::Migration[4.2]
  def change
    create_table :chaskiq_metrics do |t|
      t.references :trackable,  polymorphic: true, index: true, null: false
      t.references :campaign, index: true
      t.string :action
      t.string :host
      t.string :data
      t.timestamps null: false
    end
    #add_foreign_key :chaskiq_metrics, :trackable
  end
end
