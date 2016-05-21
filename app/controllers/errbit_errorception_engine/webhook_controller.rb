class ErrbitErrorceptionEngine::WebhookController < ApplicationController
  before_action :verify_packet
  
  def notify
    # {
    #   "isInline": true,
    #   "message": "\"_WidgetManager\" is undefined",
    #   "userAgent": "Mozilla/5.0 (Linux; U; Android 4.1.2; en-us; GT-I9100G Build/JZO54K) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
    #   "when": "after",
    #   "scriptPath": null,
    #   "page": "http://blog.rakeshpai.me/2007/02/ies-unknown-runtime-error-when-using.html",
    #   "date": "2012-11-12T15:31:02.576Z",
    #   "isFirstOccurrence": true,
    #   "webUrl": "https://errorception.com/projects/4e4b1652f384ef4d2d000002/errors/4ecc86a0fc68e61a1a06fdfc",
    #   "apiUrl": "https://api.errorception.com/projects/4e4b1652f384ef4d2d000002/errors/4ecc86a0fc68e61a1a06fdfc"
    # }
    
    return respond unless !!params[:isFirstOccurrence]
    
    puts "NOTIFY"
    puts params.inspect
    
    respond
    
    
    # ErrorReport.new(
    #   error_template.reverse_merge(
    #     api_key:            app.api_key,
    #     error_class:        "StandardError",
    #     message:            "Oops. Something went wrong!",
    #     backtrace:          random_backtrace,
    #     request:            {
    #       'component' => 'main',
    #       'action'    => 'error',
    #       'url'       => "http://example.com/post/#{[111, 222, 333].sample}"
    #     },
    #     server_environment: { 'environment-name' => Rails.env.to_s },
    #     notifier:           { name: "seeds.rb" },
    #     app_user:           {
    #       id:       "1234",
    #       username: "jsmith",
    #       name:     "John Smith",
    #       url:      "http://www.example.com/users/jsmith"
    #     }
    #   )
    # ).generate_notice!
  end
  
  private
  
  def respond
    render json: {}, status: :ok
  end
  
  def verify_packet
    puts "HEADER"
    puts request.headers.inspect
    # sha1(secret + message + page)
    # X-Signature
  end
end