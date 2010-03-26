# Camera 6

class Camera6 < Processing::App
  
  load_library :video
    
  # We need the video classes to be included here.
  include_package "processing.video"
    
  attr_accessor :capture, :sample_rate
  
  def setup    
    frame_rate 30
    smooth
    no_stroke
    size(720, 576, P3D)
    
    # set colour to RGBA.
    colorMode(RGB, 255, 255, 255, 100);
    
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
    
    (1...height).step(sample_rate) do |y|
      (1...width).step(sample_rate) do |x|
        
        pixel = y * capture.width + x
        
        r = red(capture.pixels[pixel])
        g = green(capture.pixels[pixel])
        b = blue(capture.pixels[pixel])

        c = color(r,g,b,60)
        
        base_size = 50
        

        # size = map(red(capture.pixels[pixel]), 0, 255, 0, base_size)
        # size = map(saturation(capture.pixels[pixel]), 0, 255, 0, base_size)        
        size = map(brightness(capture.pixels[pixel]), 0, 255, 0, base_size)

        
        # Calculate a z position as a function of mouseX and pixel brightness
        z = (mouseX / width.to_f) * brightness(capture.pixels[pixel]) + base_size
        # Translate to the location, set fill and stroke, and draw the rect
        pushMatrix()
        translate(x, y, z)
        fill(c)
        noStroke()
        rectMode(CENTER)
        ellipse(x, y, size, size)
        popMatrix()
        
      end
    end
    
    capture.update_pixels
  end
  
end

Camera6.new :title => "Camera 6"