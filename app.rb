require 'sinatra'
require 'sinatra/flash'
require 'haml'
require 'redis'

enable :sessions

get '/' do
  haml :index
end

post '/post' do
  token = generate_token
  REDIS.set("text:#{token}", h(params[:text]))
  REDIS.expire("text:#{token}", 600)
  flash[:success] = "Ok. Scan the QR code or copy the link below to share this item."
  redirect "/#{token}"
end

get '/:token' do
  token = params[:token]
  @text = REDIS.get("text:#{token}")
  @expire = REDIS.ttl("text:#{token}")
  if @text.nil?
    redirect '/'
  end
  haml :show
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def render(*args)
    if args.first.is_a?(Hash) && args.first.keys.include?(:partial)
      return haml "_#{args.first[:partial]}".to_sym, :layout => false
    else
      super
    end
  end

  def generate_token(max = 3)
    charset = %w{ 2 3 4 6 7 9 a c d e f g h j k m n p q r t v w x y z}
    token = (0...max).map{ charset.to_a[rand(charset.size)] }.join
  end
end

redis_uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => redis_uri.host, :port => redis_uri.port, :password => redis_uri.password)