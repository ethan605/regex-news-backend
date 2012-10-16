RegexNewsBackend::Application.routes.draw do
  root :to => 'sites#index'

  match "/doc" => "application#doc"

  resources :sites, format: false, only: %w[index] do
    collection do
      get :rules
      get :home
    end
  end
end
