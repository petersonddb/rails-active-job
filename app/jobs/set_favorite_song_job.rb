class SetFavoriteSongJob < ApplicationJob
  queue_as :favorite_songs

  def perform(*args)
    p '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
    p 'New favorite song defined!'
    p '-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
  end
end
