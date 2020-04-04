# frozen-string-literal: true

require 'rails_helper'

RSpec.describe ListenedSong, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:listener).class_name('User') }
    it { is_expected.to belong_to(:song) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:times) }
    it { is_expected.to validate_numericality_of(:times).is_greater_than(0) }
  end
end
