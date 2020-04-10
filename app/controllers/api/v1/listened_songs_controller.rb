# frozen-string-literal: true

module Api
  module V1
    class ListenedSongsController < ApplicationController
      def index
        @listened_songs = ListenedSong.all

        render json: @listened_songs, status: :ok
      end
    end
  end
end
