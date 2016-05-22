module ErrbitErrorceptionEngine
  class WebhookController < ApplicationController
    skip_before_action :authenticate_user!, only: :notify
    skip_before_action :verify_authenticity_token, only: :notify

    before_action :verify_notification
    
    def notify
      script = 'inline'

      if params[:scriptPath]
        script = params[:scriptPath]
        
        if params[:line]
          script += ":#{params[:line]}"
        end
      end
      
      ErrorReport.new(
        error_template.reverse_merge(
          api_key:            app.api_key,
          error_class:        'Errorception Notification',
          message:            params[:message],
          backtrace:          [],
          request:            {
            'url'       => params[:page],
            'script'    => script,
            'cgi-data'  => {
              'HTTP_USER_AGENT' => params[:userAgent] 
            }
          },
          server_environment: { 'environment-name' => 'production' },
          notifier:           { 
            'web-url'   => params[:webUrl],
            'api-url'   => params[:apiUrl],
          }
        )
      ).generate_notice!
      
      respond
    end
    
    private
    
    def respond
      render json: {}, status: :ok
    end
    
    def verify_notification
      components = [
        Errbit::Config.errorception_secret, 
        params[:message], 
        params[:page]
      ]
      
      Rails.logger.debug('~~ verify_notification ~~')
      Rails.logger.debug(components.join(' :: '))
      Rails.logger.debug("Signature: #{request.headers['HTTP_X_SIGNATURE'].inspect}")
      Rails.logger.debug("Generated: #{Digest::SHA1.hexdigest(components.join)}")
      
      # respond here if the signature is not what was generated.
      # this will silently fail the request.
      respond unless Digest::SHA1.hexdigest(components.join) == request.headers['HTTP_X_SIGNATURE']
    end
  end
end