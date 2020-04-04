# frozen_string_literal: true

class CreateListenedSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :listened_songs do |t|
      t.references :listener, null: false, foreign_key: { to_table: :users }
      t.references :song, null: false, foreign_key: true
      t.integer :times, null: false, default: 1

      t.timestamps
    end
  end
end
