# frozen-string-literal: true

Rails.application.routes.draw do
  namespace :api do
    scope module: :v1, constraints: Api::VersionValidator.new(1) do
      resources :listened_songs, only: :index
    end

    scope module: :v2, constraints: Api::VersionValidator.new(2, true) do
      resources :listened_songs, only: %i[index create]
    end
  end
end
