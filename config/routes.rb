Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  scope module: 'api' do
    namespace :v1 do
      resources :companies do
        put :mark_deleted, on: :member # PUT /v1/companies/:id/mark_deleted
        resources :jobs,  only: %i[index show]
        resources :geeks, only: :index
      end

      resources :jobs do
        resources :applies, only: :index
        resources :geeks,   only: :index
      end

      resources :geeks do
        put :resume, on: :member, action: :attach_resume
        resources :applies, only: :index
      end

      resources :applies do
        member do
          put :read, action: :mark_read
          put :invite
        end
      end
    end
  end

  # ловит все несуществующие пути
  match '*path', to: 'application#catch_404', via: :all
end
