class AddLastNameToPostinoSubscribers < ActiveRecord::Migration
  def change
    add_column :postino_subscribers, :last_name, :string
  end
end
