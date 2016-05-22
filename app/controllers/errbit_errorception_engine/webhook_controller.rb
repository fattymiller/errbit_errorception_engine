module ErrbitErrorceptionEngine
  class WebhookController < ApplicationController
    skip_before_action :authenticate_user!, only: :notify
    skip_before_action :verify_authenticity_token, only: :notify

    before_action :determine_application
    
    def notify
      script = 'inline'

      if params[:scriptPath]
        script = params[:scriptPath]
        
        if params[:line]
          script += ":#{params[:line]}"
        end
      end
      
      ErrorReport.new({
        api_key:            @errbit_application.api_key,
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
      }).generate_notice!
      
      respond
    end
    
    private
    
    def respond
      render json: {}, status: :ok
    end
    
    def determine_application
      @errbit_application = App.where(api_key: params[:app]).first
      return respond unless @errbit_application
      
      components = [
        @errbit_application.errorception_secret, 
        params[:message], 
        params[:page]
      ]

      signature = request.headers['HTTP_X_SIGNATURE']
      generated_signature = Digest::SHA1.hexdigest(components.join)
      
      # respond here if the signature is not what was generated.
      # this will silently fail the request.
      respond unless signature == generated_signature
      
      if params.has_key?(:debug)
        Rails.logger.debug('~~ verify_notification ~~')
        Rails.logger.debug(components.join(' :: '))
        Rails.logger.debug("Signature: #{signature.inspect}")
        Rails.logger.debug("Generated: #{generated_signature}")
      end      
    end
  end
end