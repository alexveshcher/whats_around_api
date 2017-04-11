Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/tests/try/:lat/:lng', to: 'tests#try', :constraints => { :lat => /[^\/]+/ , :lng => /[^\/]+/ }
  get '/api/v1/places/:lat/:lng/:section', to: 'tests#find_by_section', :constraints => { :lat => /[^\/]+/ , :lng => /[^\/]+/ , :sectiion => /[^\/]+/ }
end
