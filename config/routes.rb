RegexNewsBackend::Application.routes.draw do
  resources :sites, format: false, only: %w[index]
end
