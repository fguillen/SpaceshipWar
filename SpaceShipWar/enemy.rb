# The Enemy class
class Enemy
  @all = []

  class << self
    attr_reader :all
  end

  attr_reader :x, :y

  def initialize(x, y)
    @image = Gosu::Image.new("#{__dir__}/images/enemyGreen5.png")
    @x = x
    @y = y
    @velocity = Configuration::ENEMY_VELOCITY
    Enemy.all.push(self)
  end

  def update
    @y += @velocity
  end

  def draw
    @image.draw_rot(@x, @y, Configuration::Z_ENEMY)
  end

  def destroy
    Enemy.all.delete(self)
  end
end
