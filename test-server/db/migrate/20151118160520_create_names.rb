class CreateNames < ActiveRecord::Migration
  def change
    create_table :names do |t|
      t.string :name, {null: false}
      t.decimal :lat, :precision => 10, :scale => 6, :default => 0.0
      t.decimal :lng, :precision => 10, :scale => 6, :default => 0.0
      t.integer :group_id
      t.timestamps null: false
    end
  end
end
