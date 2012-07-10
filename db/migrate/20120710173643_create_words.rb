class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :name
      t.string :description
      t.integer :glossary_id

      t.timestamps
    end
  end
end
