Rails.application.routes.draw do

  mount ErrbitErrorceptionEngine::Engine => "/errbit_errorception_engine"
end
