# frozen-string-literal: true

module Songs
  class FavoriteSongIdentifier
    def initialize(listener)
      @listener = listener
    end

    def execute
      favorite_candidates = favorite_listened_songs_candidates
      favorite_candidates.each do |favorite_candidate|
        FavoriteSong.find_or_create_by(
          listener: @listener,
          song: favorite_candidate.song
        )
      end

      favorite_candidates.count
    end

    private

    def favorite_listened_songs_candidates
      ListenedSong.where(listener: @listener).where('times >= ?', 5)
    end
  end
end
