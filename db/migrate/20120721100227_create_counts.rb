class CreateCounts < ActiveRecord::Migration
  def change
    create_table :counts do |t|
      t.integer :week
      t.integer :total
      t.integer :glossary_id

      t.timestamps
    end
  end
end
