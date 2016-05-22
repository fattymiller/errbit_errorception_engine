require 'active_support/concern'

module ErrbitErrorceptionEngine::AppConcern
  extend ActiveSupport::Concern

  included do
    field :errorception_secret
  end
end