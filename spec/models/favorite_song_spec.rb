# frozen-string-literal: true

require 'rails_helper'

RSpec.describe FavoriteSong, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:listener).class_name('User') }
    it { is_expected.to belong_to(:song) }
  end

  describe 'validations' do
    subject { described_class.new(listener: listener, song: song) }

    describe '#song_listened_enough_times' do
      describe 'given a listener and a song' do
        let(:listener) { User.create(name: 'Any Name') }
        let(:song) { Song.create(name: 'Any Name') }

        describe 'and that the listener did listen to the song' do
          let(:the_listener) { listener }
          let(:the_song) { song }

          before do
            ListenedSong.create(
              listener: the_listener,
              song: the_song,
              times: times
            )
          end

          context 'when less than 5 times' do
            (1..4).each do |number|
              context "with #{number} times" do
                let(:times) { number }

                it { is_expected.to be_invalid }
              end
            end
          end

          context 'when at least 5 times' do
            [5, 7, 40].each do |number|
              context "with #{number} times" do
                let(:times) { number }

                it { is_expected.to be_valid }

                context 'with a different song' do
                  let(:the_song) { Song.create(name: 'Any Name') }

                  it { is_expected.to be_invalid }
                end

                context 'with a different listener' do
                  let(:the_listener) { User.create(name: 'Any Name') }

                  it { is_expected.to be_invalid }
                end

                context 'with different listener and song' do
                  let(:the_song) { Song.create(name: 'Any Name') }
                  let(:the_listener) { User.create(name: 'Any Name') }

                  it { is_expected.to be_invalid }
                end
              end
            end
          end
        end
      end
    end
  end
end
