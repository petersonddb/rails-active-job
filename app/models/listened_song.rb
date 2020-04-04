# frozen-string-literal: true

class ListenedSong < ApplicationRecord
  belongs_to :listener, class_name: 'User'
  belongs_to :song

  validates_presence_of :times
  validates_numericality_of :times, greater_than: 0
end
