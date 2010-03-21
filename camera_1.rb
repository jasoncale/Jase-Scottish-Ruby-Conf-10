# Camera 1

class Camera1 < Processing::App

  load_library :video
    
  # We need the video classes to be included here.
  include_package "processing.video"
    
  attr_accessor :capture
  
  def setup    
    frame_rate 30
    smooth
    size(720, 576)
    
    # You can get a list of cameras
    # by doing Capture.list
    # 
    # cameras = Capture.list.to_a
    # puts cameras
    # @capture = Capture.new(self, width, height, cameras[3], 30)
    # 
    # or you can use your default
    # webcam by leaving it out of
    # the parameters ..
    #  
    @capture = Capture.new(self, width, height, 30)     
  end

  def draw    
    capture.read if capture.available
    image capture, 0, 0
  end
  
end

@art = Camera1.new :title => "Camera Play #1"