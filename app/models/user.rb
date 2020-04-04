# frozen-string-literal: true

class User < ApplicationRecord
  validates :name, presence: true
end
