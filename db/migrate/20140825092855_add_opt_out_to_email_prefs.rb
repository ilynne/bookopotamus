class AddOptOutToEmailPrefs < ActiveRecord::Migration
  def change
    add_column :email_prefs, :opt_out, :boolean
  end
end
