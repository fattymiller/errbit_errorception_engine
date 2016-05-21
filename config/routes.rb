ErrbitErrorceptionEngine::Engine.routes.draw do
  namespace :errorception do
    post 'notify' => 'errbit_errorception_engine/webhook#notify'
  end
end
