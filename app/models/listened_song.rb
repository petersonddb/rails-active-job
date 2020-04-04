# frozen-string-literal: true

class ListenedSong < ApplicationRecord
  belongs_to :listener, class_name: 'User'
  belongs_to :song

  validates :times, presence: true
  validates :times, numericality: { greater_than: 0 }
end
