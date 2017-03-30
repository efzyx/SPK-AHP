Rails.application.routes.draw do

  devise_for :users
  get 'welcome/index'
  root 'welcome#index'
  resources :alternatives
  resources :criterions do
    resources :alternative_criterion_comparisons
  end
  resources :criterion_comparisons
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
