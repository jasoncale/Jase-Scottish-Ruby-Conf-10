# Camera 5

class Camera5 < Processing::App
  load_library :video, :minim
  
  # We need the video classes to be included here.
  include_package "processing.video"
  
  import 'ddf.minim'
  import 'ddf.minim.*'
    
  attr_accessor :capture, :sample_rate, :previous_frame
  
  def setup    
    frame_rate 20
    smooth
    size(720, 576)
    no_stroke
    background 0
    
    # set colour to RGBA.
    colorMode(RGB, 255, 255, 255, 100);

    # You can get a list of cameras
    # by doing Capture.list
    # 
    # cameras = Capture.list.to_a
    # puts cameras
    # @capture = Capture.new(self, width, height, cameras[1], 20)
    # 
    # or you can use your default
    # webcam by leaving it out of
    # the parameters ..
    #  
    @capture = Capture.new(self, width, height, 10)
    @sample_rate = 15
    
    @minim = Minim.new(self)
    
    @input = @minim.getLineIn(Minim::STEREO, 256)
  end
  
  def num_pixels
    capture.width * capture.height
  end
  
  def draw    
    if capture.available
      capture.read 
      convert_pixels
    end
  end
  
  def stop
    @input.close unless @input.nil?
    @minim.stop unless @minim.nil?
    
    super
  end
  
  def clear
    background 0
    no_stroke
    ellipse_mode(CENTER)
  end
  
  def convert_pixels
    clear
    
    buffer = map(0, 0, num_pixels, 0, @input.bufferSize)
    left_chan = map(@input.left.get(buffer).abs, 0, 1, 0, 50)
    right_chan  = map(@input.right.get(buffer).abs, 0, 1, 0, 50)
    alpha = (left_chan + right_chan)
        
    (1...height).step(sample_rate) do |y|
      (1...width).step(sample_rate) do |x|
        

        pixel = y * capture.width + x
        
        r = red(capture.pixels[pixel])
        g = green(capture.pixels[pixel])
        b = blue(capture.pixels[pixel])

        c = color(r,g,b,alpha)
        
        base_size = map(saturation(capture.pixels[pixel]), 0, 255, 0, 100)
        
        
        # size = map(red(capture.pixels[pixel]), 0, 360, 0, base_size)
        # size = map(saturation(capture.pixels[pixel]), 0, 255, 0, base_size)        
        size = map(brightness(capture.pixels[pixel]), 0, 255, 0, base_size)
        
        fill(c)

        ellipse(x, y, size, size)
      end
    end
    
    capture.update_pixels
  end
end

Camera5.new :title => "Camera 5"