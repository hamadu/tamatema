class CreateWordStars < ActiveRecord::Migration
  def change
    create_table :word_stars do |t|
      t.integer :user_id
      t.integer :word_id
      t.timestamps
    end
    add_index :word_stars, :user_id
    add_index :word_stars, :word_id
    add_index :word_stars, [:user_id, :word_id], unique: true
  end
end
