require "gosu"

# The Player class
class Player
  def initialize
    @image = Gosu::Image.new("#{__dir__}/images/starfighter.bmp")
    @x = 0
    @y = 0
    @vel_x = 0
    @vel_y = 0
    @angle = 0
    @score = 0
    @velocity = 0.5
  end

  def set_position(x:, y:)
    @x = x
    @y = y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, @velocity)
    @vel_y += Gosu.offset_y(@angle, @velocity)
  end

  def move
    @x += @vel_x
    @y += @vel_y

    @x %= 640
    @y %= 480

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end

# My Window class
class PlayerMoving < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "PlayerMoving"

    @background_image = Gosu::Image.new("#{__dir__}/images/space.png", tileable: true)
    @player = Player.new
    @player.set_position(x: 320, y: 240)
  end

  def update
    @player.turn_left if Gosu.button_down? Gosu::KB_LEFT
    @player.turn_right if Gosu.button_down? Gosu::KB_RIGHT
    @player.accelerate if Gosu.button_down? Gosu::KB_UP

    @player.move
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, 0)
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end

PlayerMoving.new.show
