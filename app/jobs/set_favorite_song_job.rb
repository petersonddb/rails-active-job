# frozen_string_literal: true

class SetFavoriteSongJob < ApplicationJob
  queue_as :favorite_songs

  def perform
    logger.info('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
    logger.info('New favorite song defined!')
    logger.info('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
  end
end
