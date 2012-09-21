RegexNewsBackend::Application.routes.draw do
  root :to => 'sites#index'
  resources :sites, format: false, only: %w[index] do
    collection do
      get :rules
      get :home
    end
  end
end
