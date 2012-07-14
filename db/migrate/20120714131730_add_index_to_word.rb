class AddIndexToWord < ActiveRecord::Migration
  def change
    add_index :glossaries, :user_id, unique: false
    add_index :words, :glossary_id, unique: false
    add_index :words, [:glossary_id, :name], unique: true
  end
end
