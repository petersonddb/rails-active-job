# frozen-string-literal: true

class FavoriteSong < ApplicationRecord
  belongs_to :listener, class_name: 'User'
  belongs_to :song

  validate :song_listened_enough_times

  private

  def song_listened_enough_times
    listened_song = ListenedSong.find_by(listener: listener, song: song)

    return if listened_song && listened_song.times >= 5

    errors.add(:listened_song, 'not enough listened')
  end
end
