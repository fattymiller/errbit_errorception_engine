ErrbitErrorceptionEngine::Engine.routes.draw do
  namespace :errorception do
    post 'notify' => 'webhook#notify'
  end
end
