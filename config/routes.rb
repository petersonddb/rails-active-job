# frozen-string-literal: true

Rails.application.routes.draw do
  namespace :api do
    scope module: :v1, constraints: Api::VersionValidator.new(1, true) do
      resources :listened_songs, only: :index
    end
  end
end
