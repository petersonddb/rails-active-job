# frozen-string-literal: true

class User < ApplicationRecord
  validates_presence_of :name
end
