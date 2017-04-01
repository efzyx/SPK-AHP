Rails.application.routes.draw do

  get 'tentang', to: 'tentang#index'

  devise_for :users
  get 'welcome/index'
  root 'welcome#index'
  resources :alternatives do
    get '*unmatched_route', to: 'error#index'
  end
  resources :criterions do
    resources :alternative_criterion_comparisons
  end
  resources :criterion_comparisons
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
