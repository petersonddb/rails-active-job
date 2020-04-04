# frozen-string-literal: true

class CreateFavoriteSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :favorite_songs do |t|
      t.references :listener, null: false, foreign_key: { to_table: :users }
      t.references :song, null: false, foreign_key: true

      t.timestamps
    end
  end
end
