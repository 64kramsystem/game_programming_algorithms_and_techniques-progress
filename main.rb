#!/usr/bin/env ruby

require 'gosu'

SCREEN_WIDTH = 960
SCREEN_HEIGHT = 600

# On each axis
PLAYER_SPEED = 10

class Test < Gosu::Window
  include Gosu

  # World coordinates
  attr_accessor :player_x, :player_y
  attr_accessor :tiles
  attr_accessor :current_tile_i
  # Screen coordinates
  attr_accessor :current_tile_x

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = "Hello World!"

    self.player_x, self.player_y = SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2
    self.tiles = Image.load_tiles("assets/doge_space.jpg", SCREEN_WIDTH, SCREEN_HEIGHT)[0, 2]
  end

  def update
    handle_exit_input

    self.player_x, self.player_y = compute_player_position_from_input
    self.current_tile_i, self.current_tile_x = compute_tile_position
  end

  def draw
    draw_player
    draw_background
  end

  private

  def handle_exit_input
    close if button_down?(KB_ESCAPE)
  end

  def compute_player_position_from_input
    player_x, player_y = self.player_x, self.player_y

    player_x = (player_x - PLAYER_SPEED).clamp(0, self.tiles.size * SCREEN_WIDTH - 1) if button_down?(KB_A)
    player_x = (player_x + PLAYER_SPEED).clamp(0, self.tiles.size * SCREEN_WIDTH - 1) if button_down?(KB_D)
    player_y = (player_y - PLAYER_SPEED).clamp(0, SCREEN_HEIGHT) if button_down?(KB_W)
    player_y = (player_y + PLAYER_SPEED).clamp(0, SCREEN_HEIGHT) if button_down?(KB_S)

    [player_x, player_y]
  end

  def compute_tile_position
    # There are slightly different references that can be used; this is just an option.

    # Adjust for the player being in the middle of the screen.
    world_reference_x = (self.player_x - SCREEN_WIDTH / 2).clamp(0, SCREEN_WIDTH * (self.tiles.size - 1))

    tile_i = world_reference_x / SCREEN_WIDTH

    # The distance of the player from the reference is the start of the tile drawing, on the opposite direction.
    tile_x = -(world_reference_x % SCREEN_WIDTH)

    [tile_i, tile_x]
  end

  def draw_player
    # When the player is in the outermost half screens, don't anchor it to the center anymore.
    player_screen_x = if self.player_x <= SCREEN_WIDTH / 2 || self.player_x >= self.tiles.size * SCREEN_WIDTH - SCREEN_WIDTH / 2
      player_x % SCREEN_WIDTH
    else
      SCREEN_WIDTH / 2
    end

    draw_rect(player_screen_x, player_y, 1, 1, Color::YELLOW, 1)
  end

  def draw_background
    self.tiles[self.current_tile_i].draw(self.current_tile_x, 0, 0)

    # For simplicity, draw also if outside the screen.
    self.tiles.dig(self.current_tile_i + 1)&.draw(self.current_tile_x + SCREEN_WIDTH, 0, 0)
  end
end

Test.new.show
