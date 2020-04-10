# frozen-string-literal: true

module Api
  module V2
    class ListenedSongsController < ApplicationController
      def index
        @listened_songs = ListenedSong.all

        return head :not_found if @listened_songs.empty?

        render json: @listened_songs, status: :ok
      end

      def create
        @listened_song = ListenedSong.new(listened_song_params)

        return unless @listened_song.save

        render json: { id: @listened_song.id }, status: :created
      end

      private

      def listened_song_params
        params.permit(
          :listener_id,
          :song_id,
          :times
        )
      end
    end
  end
end
