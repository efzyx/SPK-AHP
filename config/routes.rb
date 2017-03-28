Rails.application.routes.draw do


  get 'welcome/index'
  root 'welcome#index'
  resources :alternatives
  resources :criterions
  resources :criterion_comparisons
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
