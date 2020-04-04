# frozen-string-literal: true

require 'rails_helper'

RSpec.describe Songs::FavoriteSongIdentifier do
  let(:favorite_song_identifier) { described_class.new(listener) }

  describe '#execute' do
    subject(:execute) { favorite_song_identifier.execute }

    describe 'given a listener' do
      let(:listener) { User.create(name: 'Any Name') }

      context 'when there are NO listened songs to be favorited' do
        it { is_expected.to eq(0) }
      end

      context 'when there are some listened songs' do
        let!(:other_listener_listened_songs) do
          (1..3).map do |number|
            ListenedSong.create(
              listener: User.create(name: 'Any Other Name'),
              song: Song.create(name: "Any Other Name #{number}"),
              times: 5
            )
          end
        end

        let!(:not_enough_times_listened_songs) do
          (1..3).map do |number|
            ListenedSong.create(
              listener: listener,
              song: Song.create(name: "Any Different Name #{number}"),
              times: 1
            )
          end
        end

        [1, 4, 11].each do |count|
          context "with #{count} candidate(s)" do
            let(:listened_songs) do
              (1..count).map do |number|
                ListenedSong.create(
                  listener: listener,
                  song: Song.create(name: "Any Name #{number}"),
                  times: 5
                )
              end
            end

            context 'with one candidate already favorited' do
              let!(:already_favorited) do
                FavoriteSong.create(
                  listener: listened_songs.sample.listener,
                  song: listened_songs.sample.song
                )
              end

              it { is_expected.to eq(count) }

              it do
                expect { execute }.to change(
                  FavoriteSong, :count
                ).by(count - 1)
              end

              it 'mark the other candidate songs as favorite' do
                execute

                (listened_songs - [already_favorited]).each do |listened_song|
                  expect(
                    FavoriteSong.find_by(
                      listener: listened_song.listener,
                      song: listened_song.song
                    )
                  ).not_to be_nil
                end
              end

              it 'does NOT mark any other song as favorite' do
                execute

                non_candidate_listened_songs = other_listener_listened_songs +
                                               not_enough_times_listened_songs
                non_candidate_listened_songs.each do |listened_song|
                  expect(
                    FavoriteSong.find_by(
                      listener: listened_song.listener,
                      song: listened_song.song
                    )
                  ).to be_nil
                end
              end
            end
          end
        end
      end
    end
  end
end
