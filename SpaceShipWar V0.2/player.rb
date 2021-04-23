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

  def shoot
    Bullet.new(@x, @y - 40, Configuration::PLAYER_BULLET_IMAGE, Configuration::PLAYER_BULLET_VELOCITY, Bullet::KINDS[:player])
    LaserFlash.new(@x, @y - 40)
  end
end
