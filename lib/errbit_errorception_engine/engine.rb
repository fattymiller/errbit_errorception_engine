module ErrbitErrorceptionEngine
  class Engine < ::Rails::Engine
    isolate_namespace ErrbitErrorceptionEngine

    initializer 'config.errorception.concerns' do
      decorate_classes
    end
    
    def decorate_classes
      App.class_eval do
        include ErrbitErrorceptionEngine::AppConcern
      end
    end
  end
end
