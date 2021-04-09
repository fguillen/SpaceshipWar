require "gosu"

module Configuration
  WINDOW_WIDTH = 640
  WINDOW_HEIGHT = 480
  PLAYER_VELOCITY = 0.5
  PLAYER_ANGULAR_VELOCITY = 4.5
  PLAYER_DECELERATION_VELOCITY = 0.95

  Z_BACKGROUND = 0
  Z_STARS = 1
  Z_PLAYER = 2
  Z_UI = 3
end

# The Collectable Stars
class Star
  attr_reader :x, :y

  def initialize(animation)
    @animation = animation
    @color = create_random_color
    @x, @y = create_random_position
    @animation_offset = rand(@animation.size)
  end

  def create_random_color
    color = Gosu::Color::BLACK.dup
    color.red = rand(256 - 40) + 40
    color.green = rand(256 - 40) + 40
    color.blue = rand(256 - 40) + 40

    color
  end

  def create_random_position
    x = rand * Configuration::WINDOW_WIDTH
    y = rand * Configuration::WINDOW_HEIGHT

    [x, y]
  end

  def draw
    img = @animation[((Gosu.milliseconds / 100) + @animation_offset) % @animation.size]
    img.draw(
      @x - img.width / 2.0,
      @y - img.height / 2.0,
      Configuration::Z_STARS,
      1,
      1,
      @color,
      :add
    )
  end
end

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
    @velocity = Configuration::PLAYER_VELOCITY
  end

  def set_position(x:, y:)
    @x = x
    @y = y
  end

  def turn_left
    @angle -= Configuration::PLAYER_ANGULAR_VELOCITY
  end

  def turn_right
    @angle += Configuration::PLAYER_ANGULAR_VELOCITY
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, @velocity)
    @vel_y += Gosu.offset_y(@angle, @velocity)
  end

  def move
    @x += @vel_x
    @y += @vel_y

    @x %= Configuration::WINDOW_WIDTH
    @y %= Configuration::WINDOW_HEIGHT

    @vel_x *= Configuration::PLAYER_DECELERATION_VELOCITY
    @vel_y *= Configuration::PLAYER_DECELERATION_VELOCITY
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  attr_reader :score

  def collect_stars(stars)
    stars.reject! { |star| Gosu.distance(@x, @y, star.x, star.y) < 25 }
  end
end

# My Window class
class PlayerMoving < Gosu::Window
  def initialize
    super Configuration::WINDOW_WIDTH, Configuration::WINDOW_HEIGHT
    self.caption = "PlayerMoving"

    @background_image = Gosu::Image.new("#{__dir__}/images/space.png", tileable: true)
    @player = Player.new
    @player.set_position(x: 320, y: 240)

    @star_anim = Gosu::Image.load_tiles("#{__dir__}/images/star.png", 25, 25)
    @stars = []

    @font = Gosu::Font.new(20)
  end

  def update
    @player.turn_left if Gosu.button_down? Gosu::KB_LEFT
    @player.turn_right if Gosu.button_down? Gosu::KB_RIGHT
    @player.accelerate if Gosu.button_down? Gosu::KB_UP

    @player.move
    @player.collect_stars(@stars)

    @stars.push(Star.new(@star_anim)) if (rand(100) < 4) && (@stars.size < 25)
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, 0)
    @stars.each(&:draw)
    @font.draw_text("Score: #{@player.score}", 10, 10, Configuration::Z_UI, 1.0, 1.0, Gosu::Color::YELLOW)
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
