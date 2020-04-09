# frozen-string-literal: true

class SetFavoriteSongJob < ApplicationJob
  queue_as :favorite_songs

  def perform
    SetFavoriteSongJob.set(wait: 1.day).perform_later

    User.all.each do |listener|
      Songs::FavoriteSongIdentifier.new(listener).execute
    end
  end
end
