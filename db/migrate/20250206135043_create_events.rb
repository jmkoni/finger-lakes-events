class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_enum :status_types, [
      "approved",
      "pending",
      "rejected"
    ]

    create_table :events do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.string :title, null: false
      t.string :url
      t.text :description
      t.text :location
      t.string :event_type
      t.string :tags, array: true, default: []
      t.float :cost, null: false, default: 0.0
      t.enum :status, enum_type: :status_types, default: "pending", null: false
      t.references :approved_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
