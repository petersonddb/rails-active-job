# frozen-string-literal: true

require 'rails_helper'

RSpec.describe Api::V2::ListenedSongsController, type: :controller do
  describe 'GET /listened_songs' do
    subject(:get_listened_songs) { get :index, format: :json }

    describe 'given NO listened songs' do
      it { is_expected.to have_http_status(:not_found) }
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

      describe 'response body' do
        it do
          get_listened_songs

          expect(
            JSON.parse(response.body, symbolize_names: true)
          ).to match_array(
            JSON.parse(listened_songs.to_json, symbolize_names: true)
          )
        end
      end
    end
  end

  describe 'POST /listened_songs' do
    subject(:post_listened_songs) do
      post(
        :create,
        format: :json,
        params: params
      )
    end

    describe 'given valid params' do
      let(:params) do
        {
          listener_id: User.create(name: 'Any Name').id,
          song_id: Song.create(name: 'Any Name').id,
          times: rand(1..10)
        }
      end

      it { is_expected.to have_http_status(:created) }

      describe 'response body' do
        it 'is expected to have the listened song identification' do
          post_listened_songs

          expect(
            JSON.parse(response.body, symbolize_names: true)[:id]
          ).to eq(ListenedSong.last.id)
        end
      end

      describe 'created listened song' do
        before { post_listened_songs }

        it 'is expected to have the correct listener' do
          expect(ListenedSong.last.listener_id).to eq params[:listener_id]
        end

        it 'is expected to have the correct song' do
          expect(ListenedSong.last.song_id).to eq params[:song_id]
        end

        it 'is expected to have the correct times' do
          expect(ListenedSong.last.times).to eq params[:times]
        end
      end
    end
  end
end
