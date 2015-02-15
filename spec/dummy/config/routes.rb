Rails.application.routes.draw do

  root 'welcome#index'
  get '/hello' => 'welcome#hello'
end
