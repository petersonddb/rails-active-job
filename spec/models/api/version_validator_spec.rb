# frozen-string-literal: true

require 'rails_helper'

RSpec.describe Api::VersionValidator, type: :model do
  let(:a_version) { 1 }
  let(:other_version) { 2 }

  let(:a_validator) { described_class.new(a_version) }
  let(:other_default_validator) { described_class.new(other_version, true) }

  describe '#matches?' do
    describe 'given some requests' do
      let(:no_version_request) do
        instance_double(
          'Without version request',
          headers: {}
        )
      end

      let(:a_version_request) do
        instance_double(
          'A version request',
          headers: {
            'Accept': "application/vnd.railsactivejobs.v#{a_version}"
          }
        )
      end

      let(:other_version_request) do
        instance_double(
          'Other version request',
          headers: {
            'Accept': "application/vnd.railsactivejobs.v#{other_version}"
          }
        )
      end

      context 'with a version validator' do
        subject { a_validator }

        it { is_expected.to be_matches(a_version_request) }
        it { is_expected.not_to be_matches(other_version_request) }
        it { is_expected.not_to be_matches(no_version_request) }
      end

      context 'with other version validator, as default' do
        subject { other_default_validator }

        it { is_expected.to be_matches(a_version_request) }
        it { is_expected.to be_matches(other_version_request) }
        it { is_expected.to be_matches(no_version_request) }
      end
    end
  end
end
