# Train

class Train < Processing::App
  load_library :video
    
  # We need the video classes to be included here.
  include_package "processing.video"
    
  attr_accessor :capture, :sample_rate
  
  def setup    
    frame_rate 30
    smooth
    no_stroke
    size(720, 576)
    
    # set colour to RGBA.
    colorMode(RGB, 255, 255, 255, 100);
    
    ellipse_mode(CENTER)
    

    cameras = Capture.list.to_a
    puts cameras

    @capture = Capture.new(self, width, height, cameras[2], 30)
    @sample_rate = 10
    @last_time = millis()
    
    @x = 0
    @y = 0
    
    @mm = MovieMaker.new(self, width, height, "train-#{millis()}.mov", 30, MovieMaker::H263, MovieMaker::HIGH)
    
    background(204)
  end
  
  def clear
    background(204)
  end
  
  def draw
    time = millis()
    if time > @last_time + 10000
      if capture.available?
        capture.read
        convert_pixels
      end
    end
  end
  
  def convert_pixels
    #clear
    
    (1...height).step(sample_rate) do |y|
      (1...width).step(sample_rate) do |x|
        
        pixel = y * capture.width + x
        
        r = red(capture.pixels[pixel])
        g = green(capture.pixels[pixel])
        b = blue(capture.pixels[pixel])

        c = color(r,g,b,60)
        
        base_size = 100

        # size = map(red(capture.pixels[pixel]), 0, 255, 0, base_size)
        size = map(saturation(capture.pixels[pixel]), 0, 255, 0, base_size)        
        # size = map(brightness(capture.pixels[pixel]), 0, 255, 0, base_size)

        fill(c)

        ellipse(x, y, size, size)
      end
    end
    
    capture.update_pixels
    
    @mm.addFrame();
  end
  
  def key_pressed
    if key == ' '
      puts "space"        
      @mm.finish 
    end
  end
  
end

Train.new :title => "Train"