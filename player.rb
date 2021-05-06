# The Player class
class Player
  attr_reader :x, :y, :state

  def initialize(x, y)
    @image = Gosu::Image.new("#{__dir__}/images/playerShip1_red.png")
    @x = x
    @y = y
    @velocity = Configuration::PLAYER_VELOCITY
    @state = "alive"
  end

  def draw
    if is_alive?
      @image.draw_rot(@x, @y, Configuration::Z_PLAYER)
    end
  end

  def update
    move
  end

  def move
    move_left if Gosu.button_down? Gosu::KB_LEFT
    move_right if Gosu.button_down? Gosu::KB_RIGHT
    move_up if Gosu.button_down? Gosu::KB_UP
    move_down if Gosu.button_down? Gosu::KB_DOWN
  end

  def move_left
    @x -= @velocity
  end

  def move_right
    @x += @velocity
  end

  def move_up
    @y -= @velocity
  end

  def move_down
    @y += @velocity
  end

  def shoot
    Bullet.new(@x, @y - 40, Configuration::PLAYER_BULLET_IMAGE, Configuration::PLAYER_BULLET_VELOCITY, Bullet::KINDS[:player])
    LaserFlash.new(@x, @y - 40)
  end

  def destroy
    @state = "dead"
  end

  def is_alive?
    @state == "alive"
  end
end
