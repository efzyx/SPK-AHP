Rails.application.routes.draw do

  get 'welcome/index'
  root 'welcome#index'
  resources :alternatives do
    resources :alternative_criterion_comparisons
  end
  resources :criterions
  resources :criterion_comparisons
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
