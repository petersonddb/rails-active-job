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
        subject(:response_body) do
          get_listened_songs

          JSON.parse(response.body, symbolize_names: true)
        end

        it do
          expect(response_body).to match_array(
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

      describe 'set favorite song identifier job' do
        subject(:favorite_song_job) do
          post_listened_songs

          SetFavoriteSongJob
        end

        it do
          ActiveJob::Base.queue_adapter = :test

          expect(favorite_song_job).to(
            have_been_enqueued.on_queue('favorite_songs').exactly(:once)
          )
        end
      end

      describe 'response body' do
        subject(:response_body) do
          post_listened_songs

          JSON.parse(response.body, symbolize_names: true)
        end

        it 'is expected to have the listened song identification' do
          expect(response_body[:id]).to eq(ListenedSong.last.id)
        end
      end

      describe 'created listened song' do
        subject(:created_listened_song) do
          post_listened_songs

          ListenedSong.last
        end

        it 'is expected to have the correct listener' do
          expect(created_listened_song.listener_id).to eq params[:listener_id]
        end

        it 'is expected to have the correct song' do
          expect(created_listened_song.song_id).to eq params[:song_id]
        end

        it 'is expected to have the correct times' do
          expect(created_listened_song.times).to eq params[:times]
        end
      end
    end

    describe 'given invalid params' do
      let(:params) { { listener: nil, song: nil, times: 0 } }

      it { is_expected.to have_http_status(:unprocessable_entity) }

      describe 'response body' do
        subject(:response_body) do
          post_listened_songs

          JSON.parse(response.body, symbolize_names: true)
        end

        it 'is expected to have the correct error message' do
          expect(response_body[:error]).to eq('Validation failed!')
        end
      end
    end
  end
end
