#!/usr/bin/env ruby

require 'gosu'

SCREEN_WIDTH = 960
SCREEN_HEIGHT = 600

class Test < Gosu::Window
  include Gosu

  attr_accessor :player_x, :player_y, :tiles

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = "Hello World!"

    self.player_x, self.player_y = SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2

    self.tiles = Image.load_tiles("assets/doge_space.jpg", SCREEN_WIDTH, SCREEN_HEIGHT)
  end

  def update
    close if button_down?(KB_ESCAPE)

    self.player_y = (self.player_y - 1).clamp(0, SCREEN_HEIGHT) if button_down?(KB_W)
    self.player_y = (self.player_y + 1).clamp(0, SCREEN_HEIGHT) if button_down?(KB_S)
    self.player_x = (self.player_x - 1).clamp(0, SCREEN_WIDTH) if button_down?(KB_A)
    self.player_x = (self.player_x + 1).clamp(0, SCREEN_WIDTH) if button_down?(KB_D)
  end

  def draw
    draw_rect(player_x, player_y, 1, 1, Color::YELLOW, 1)

    tile_i = (milliseconds / 1000) % self.tiles.size
    self.tiles[tile_i].draw(0, 0, 0)
  end
end

Test.new.show
