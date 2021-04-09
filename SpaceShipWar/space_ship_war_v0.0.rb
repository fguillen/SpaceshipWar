require "gosu"

module Configuration
  WINDOW_WIDTH = 640
  WINDOW_HEIGHT = 920
  PLAYER_VELOCITY = 5

  Z_BACKGROUND = 0
  Z_ENEMIES = 1
  Z_PLAYER = 2
  Z_UI = 3
end

# The Player class
class Player
  def initialize(x, y)
    @image = Gosu::Image.new("#{__dir__}/images/playerShip1_red.png")
    @x = x
    @y = y
    @velocity = Configuration::PLAYER_VELOCITY
  end

  def draw
    @image.draw_rot(@x, @y, Configuration::Z_PLAYER)
  end

  def move_left
    @x -= @velocity
  end

  def move_right
    @x += @velocity
  end
end

# The Main Class
class SpaceShipWar < Gosu::Window
  def initialize
    super Configuration::WINDOW_WIDTH, Configuration::WINDOW_HEIGHT
    self.caption = "SpaceShip War"

    @player = Player.new(Configuration::WINDOW_WIDTH / 2, Configuration::WINDOW_HEIGHT - 100)
  end

  def update
    @player.move_left if Gosu.button_down? Gosu::KB_LEFT
    @player.move_right if Gosu.button_down? Gosu::KB_RIGHT
  end

  def draw
    @player.draw
  end
end

SpaceShipWar.new.show