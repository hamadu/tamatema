class AddReadToWord < ActiveRecord::Migration
  def change
    add_column :words, :read, :string
  end
end
