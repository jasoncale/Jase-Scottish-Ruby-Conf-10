# Camera 4

# require 'rubygems'
# require 'httparty'

# tweets = HTTParty.get('http://search.twitter.com/search.json', 
#   :query => {:q => "#musicmonday", :rrp => "3"}, 
#   :format => :json, 
#   :headers => {'User-Agent' => 'Ruby Twitter Gem'}
# )["results"].collect{|result| result["text"] }

require 'rubygems'
Gem.clear_paths
ENV['GEM_HOME'] = "/Users/jasoncale/.rvm/gems/jruby-1.4.0"
ENV['GEM_PATH'] = "/Users/jasoncale/.rvm/gems/jruby-1.4.0"

require "json"
require 'net/http'

class Camera4 < Processing::App

  load_library :video
    
  # We need the video classes to be included here.
  include_package "processing.video"
    
  attr_accessor :capture, :sample_rate
  
  def setup    
    frame_rate 30
    smooth
    size(720, 576)
    
    # set colour to RGBA.
    colorMode(RGB, 255, 255, 255, 100);
    
    text_font load_font("Univers66.vlw.gz")
    
    # You can get a list of cameras
    # by doing Capture.list
    # 
    # cameras = Capture.list.to_a
    # puts cameras
    # @capture = Capture.new(self, width, height, cameras[1], 30)
    # 
    # or you can use your default
    # webcam by leaving it out of
    # the parameters ..
    #  
    @capture = Capture.new(self, width, height, 30)
    @sample_rate = 10
    
    process_tweets("ruby")
  end
  
  def process_tweets(keyword)
    # @tweets = File.readlines("data/tweets.txt").join(" ")
    
    tweets_json = Net::HTTP.get_response('www.twitter.com', "/search.json?q=#{keyword}").body    
    @tweets = JSON(tweets_json)["results"].collect{|result| result["text"] }.join(" ")
    @tweet_chars = @tweets.unpack("A1" * @tweets.length)
  end

  def draw    
    capture.read if capture.available
    convert_pixels
  end
  
  def clear
    background 0
    no_stroke
    ellipse_mode(CENTER)
  end
  
  def convert_pixels
    clear
    
    tweet_char = 0
    
    (1...height).step(sample_rate) do |y|
      (1...width).step(sample_rate) do |x|
        
        pixel = y * capture.width + x
        
        r = red(capture.pixels[pixel])
        g = green(capture.pixels[pixel])
        b = blue(capture.pixels[pixel])

        c = color(r,g,b,90)
        
        base_size = sample_rate
        
        size = map(red(capture.pixels[pixel]), 0, 255, 0, base_size)

        fill(c)
        
        if tweet_char >= @tweet_chars.length
          tweet_char = 0
        end
        
        # ellipse(x, y, e_width, e_width)
        textSize(size * 2)
        
        text(@tweet_chars[tweet_char], x, y)
        
        tweet_char += 1
      end
    end
    
    # capture.update_pixels
  end
  
end

@art = Camera4.new :title => "Camera Play #4"