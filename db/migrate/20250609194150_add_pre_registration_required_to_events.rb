class AddPreRegistrationRequiredToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :pre_registration_required, :boolean, default: false, null: false
    remove_column :events, :event_type, :string
  end
end
