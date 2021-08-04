#!/usr/bin/env ruby

require 'gosu'

SCREEN_WIDTH = 960
SCREEN_HEIGHT = 600

TILES_X_COUNT = 2

# On each axis
PLAYER_SPEED = 10

class Test < Gosu::Window
  include Gosu

  # World coordinates
  attr_accessor :player_x, :player_y
  # Bidimensional array
  attr_accessor :tiles
  # The reference tile is the top left visible one
  attr_accessor :reference_tile_row, :reference_tile_col
  # Screen coordinates
  attr_accessor :reference_tile_x, :reference_tile_y

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = "Hello World!"

    self.player_x, self.player_y = SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2
    self.tiles = Image.load_tiles("assets/doge_space.jpg", SCREEN_WIDTH, SCREEN_HEIGHT).each_slice(TILES_X_COUNT).to_a
  end

  def update
    handle_exit_input

    self.player_x, self.player_y = compute_player_position_from_input
    self.reference_tile_row, self.reference_tile_col, self.reference_tile_x, self.reference_tile_y = compute_tile_position
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

    player_x = (player_x - PLAYER_SPEED).clamp(0, TILES_X_COUNT * SCREEN_WIDTH - 1) if button_down?(KB_A)
    player_x = (player_x + PLAYER_SPEED).clamp(0, TILES_X_COUNT * SCREEN_WIDTH - 1) if button_down?(KB_D)
    player_y = (player_y - PLAYER_SPEED).clamp(0, self.tiles.size * SCREEN_HEIGHT - 1) if button_down?(KB_W)
    player_y = (player_y + PLAYER_SPEED).clamp(0, self.tiles.size * SCREEN_HEIGHT - 1) if button_down?(KB_S)

    [player_x, player_y]
  end

  def compute_tile_position
    # There are slightly different references that can be used; this is just an option.

    # Adjust for the player being in the middle of the screen.
    world_reference_x = (self.player_x - SCREEN_WIDTH / 2).clamp(0, SCREEN_WIDTH * (TILES_X_COUNT - 1))

    tile_col = world_reference_x / SCREEN_WIDTH

    # The distance of the player from the reference is the start of the tile drawing, on the opposite direction.
    tile_x = -(world_reference_x % SCREEN_WIDTH)

    world_reference_y = (self.player_y - SCREEN_HEIGHT / 2).clamp(0, SCREEN_HEIGHT * (self.tiles.size - 1))
    tile_row = world_reference_y / SCREEN_HEIGHT
    tile_y = -(world_reference_y % SCREEN_HEIGHT)

    [tile_row, tile_col, tile_x, tile_y]
  end

  def draw_player
    # When the player is in the outermost half screens, don't anchor it to the center anymore.
    player_screen_x = if self.player_x <= SCREEN_WIDTH / 2 || self.player_x >= TILES_X_COUNT * SCREEN_WIDTH - SCREEN_WIDTH / 2
      player_x % SCREEN_WIDTH
    else
      SCREEN_WIDTH / 2
    end

    player_screen_y = if self.player_y <= SCREEN_HEIGHT / 2 || self.player_y >= self.tiles.size * SCREEN_HEIGHT - SCREEN_HEIGHT / 2
      player_y % SCREEN_HEIGHT
    else
      SCREEN_HEIGHT / 2
    end

    draw_rect(player_screen_x, player_screen_y, 1, 1, Color::YELLOW, 1)
  end

  def draw_background
    self.tiles.dig(self.reference_tile_row, self.reference_tile_col).draw(self.reference_tile_x, self.reference_tile_y, 0)

    # For simplicity, draw also if outside the screen.

    self.tiles.dig(self.reference_tile_row, self.reference_tile_col + 1)&.draw(self.reference_tile_x + SCREEN_WIDTH, self.reference_tile_y, 0)
    self.tiles.dig(self.reference_tile_row + 1, self.reference_tile_col)&.draw(self.reference_tile_x, self.reference_tile_y + SCREEN_HEIGHT, 0)
    self.tiles.dig(self.reference_tile_row + 1, self.reference_tile_col + 1)&.draw(self.reference_tile_x + SCREEN_WIDTH, self.reference_tile_y + SCREEN_HEIGHT, 0)
  end
end

Test.new.show
