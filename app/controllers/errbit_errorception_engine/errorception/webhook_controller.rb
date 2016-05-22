module Errorception
  class WebhookController < ApplicationController
    before_action :verify_notification
    
    def notify
      if !!params[:isFirstOccurrence]
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
      end
      
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
      
      # respond here if the signature is not what was generated.
      # this will silently fail the request.
      respond unless Digest::SHA.hexdigest(components.join) == request.headers['X-Signature']
    end
  end
end