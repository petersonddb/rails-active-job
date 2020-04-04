# frozen_string_literal: true

class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.string :name

      t.timestamps

      t.index :name, unique: true
    end
  end
end
