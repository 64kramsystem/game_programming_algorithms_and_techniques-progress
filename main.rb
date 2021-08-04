#!/usr/bin/env ruby

require 'gosu'

TILE_WIDTH = 960
TILE_HEIGHT = 600

class Test < Gosu::Window
  def initialize
    super(TILE_WIDTH, TILE_HEIGHT)
    self.caption = "Hello World!"

    @tiles = Gosu::Image.load_tiles("assets/doge_space.jpg", TILE_WIDTH, TILE_HEIGHT)
  end

  def update
    # ...
  end

  def draw
    tile_i = (Gosu.milliseconds / 1000) % @tiles.size
    @tiles[tile_i].draw(0, 0, 0)
  end
end

Test.new.show
