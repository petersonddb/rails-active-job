# frozen-string-literal: true

require 'rails_helper'

RSpec.describe SetFavoriteSongJob, type: :job do
  subject(:perform_now) { described_class.perform_now }

  describe 'given some listeners' do
    let(:listeners) do
      (1..3).map do |number|
        User.create(name: "Any Name #{number}")
      end
    end

    let(:favorite_song_identifier) do
      instance_spy('Songs::FavoriteSongIdentifier')
    end

    before do
      listeners.each do |listener|
        allow(
          Songs::FavoriteSongIdentifier
        ).to receive(:new).with(
          listener
        ).and_return(favorite_song_identifier)
      end
    end

    it do
      perform_now

      expect(
        favorite_song_identifier
      ).to have_received(:execute).exactly(listeners.count)
    end
  end
end
