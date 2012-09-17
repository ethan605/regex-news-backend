RegexNewsBackend::Application.routes.draw do
  resources :sites, format: false, only: %w[index] do
    collection do
      get :rules
    end
  end
end
