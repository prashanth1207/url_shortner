Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'urls#index'
  post 'create', to: 'urls#create'
  get ':id/show', to: 'urls#show'
  get 'url_stats', to: 'urls#url_stats'
  get ':short_url', to: 'urls#redirect'
end
