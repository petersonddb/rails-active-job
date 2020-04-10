# frozen-string-literal: true

require 'rails_helper'

RSpec.describe Api::V1::ListenedSongsController, type: :controller do
  describe 'GET /index' do
    subject(:get_index) { get :index, format: :json }

    describe 'given NO listened songs' do
      it { is_expected.to have_http_status(:ok) }

      it do
        get_index

        expect(
          JSON.parse(response.body, symbolize_names: true)
        ).to be_empty
      end
    end

    describe 'given some listened songs' do
      let!(:listened_songs) do
        (1..3).map do |number|
          ListenedSong.create(
            listener: User.create(name: "Any Name #{number}"),
            song: Song.create(name: "Any Name #{number}")
          )
        end
      end

      it { is_expected.to have_http_status(:ok) }

      it do
        get_index

        expect(
          JSON.parse(response.body, symbolize_names: true)
        ).to match_array(
          JSON.parse(listened_songs.to_json, symbolize_names: true)
        )
      end
    end
  end
end
