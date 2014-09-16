#!/usr/bin/env ruby

require File.expand_path("../lib/dependency", __FILE__)

#
# Animation / retrofy example
#
class Game < Chingu::Window  
  def initialize
    super    
    self.factor = 1
    self.input = { :escape => :exit }
		self.caption = "Chingu::Animation / retrofy example. Move with arrows!"
    retrofy
    Droid.create(:x => $window.width/2, :y => $window.height/2)
  end
end

class Droid < Chingu::GameObject
  traits :timer
  
  def initialize(options = {})
    super
    
    #
    # This shows up the shorten versio of input-maps, where each key calls a method of the very same name.
    # Use this by giving an array of symbols to self.input
    #
    self.input = [:holding_left, :holding_right, :holding_up, :holding_down]
    
    # Load the full animation from tile-file media/droid.bmp
    @animation = Chingu::Animation.new(:file => File.expand_path("../media/reimu.png", __FILE__), :size => [133, 224])
    @animation.frame_names = { :up => 2, :down => 1, :left => 3, :right => 0 }
    #raise @animation.frames.to_yaml
    
    # Start out by animation frames 0-5 (contained by @animation[:scan])
    @frame_name = :left
    
    @last_x, @last_y = @x, @y
    update
  end
    
  def holding_left
    puts "Move Left"
    @x -= 2
    @y += 2
    @frame_name = :left
  end

  def holding_right
    puts "Move Right"
    @x += 2
    @y -= 2
    @frame_name = :right
  end
  
  def holding_up
    puts "Move Up"
    @y -= 2
    @x -= 2
    @frame_name = :up
  end

  def holding_down
    puts "Move Down"
    @y += 2
    @x += 2
    @frame_name = :down
  end

  # We don't need to call super() in update().
  # By default GameObject#update is empty since it doesn't contain any gamelogic to speak of.
  def update
    
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation[@frame_name]
    
    #
    # If droid stands still, use the scanning animation
    #
    #@frame_name = :scan if @x == @last_x && @y == @last_y
    
    @x, @y = @last_x, @last_y if outside_window?  # return to previous coordinates if outside window
    @last_x, @last_y = @x, @y                     # save current coordinates for possible use next time
  end
end

Game.new.show