Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :v1 do
    post 'research_import' => 'research_import#import'
    delete 'reset_database' => 'research_import#reset_database'
    get 'employees' => 'employees#index'
    get 'organizations' => 'organizations#index'
    get 'questions' => 'questions#index'
    get 'survey_responses' => 'survey_responses#index'
  end
end
