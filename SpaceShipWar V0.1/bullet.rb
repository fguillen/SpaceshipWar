# The Bullet class
class Bullet
  @all = []

  class << self
    attr_reader :all
  end

  attr_reader :x, :y

  def initialize(x, y)
    @image = Gosu::Image.new("#{__dir__}/images/laserBlue02.png")
    @x = x
    @y = y
    @velocity = Configuration::BULLET_VELOCITY

    Bullet.all.push(self)
  end

  def update
    @y -= @velocity
  end

  def draw
    @image.draw_rot(@x, @y, Configuration::Z_BULLET)
  end

  def destroy
    Bullet.all.delete(self)
  end
end
