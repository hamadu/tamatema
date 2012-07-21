class AddPrivateFlagToGlossary < ActiveRecord::Migration
  def change
    add_column :glossaries, :private, :string
  end
end
