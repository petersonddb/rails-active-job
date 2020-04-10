# frozen-string-literal: true

module Api
  module V2
    class ListenedSongsController < ApplicationController
      def index
        @listened_songs = ListenedSong.all

        return head :not_found if @listened_songs.empty?

        render json: @listened_songs, status: :ok
      end
    end
  end
end
