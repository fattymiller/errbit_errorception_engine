ErrbitErrorceptionEngine::Engine.routes.draw do
  post 'notify' => 'webhook#notify'
end
