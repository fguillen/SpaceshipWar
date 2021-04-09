require "gosu"

module Configuration
  WINDOW_WIDTH = 640
  WINDOW_HEIGHT = 920
  PLAYER_VELOCITY = 5
  BULLET_VELOCITY = 20
  ENEMY_VELOCITY = 2

  Z_BACKGROUND = 0
  Z_ENEMY = 1
  Z_PLAYER = 2
  Z_BULLET = 3
  Z_UI = 4
end

# The Enemy class
class Enemy
  attr_reader :x, :y

  def initialize(x, y)
    @image = Gosu::Image.new("#{__dir__}/images/enemyGreen5.png")
    @x = x
    @y = y
    @velocity = Configuration::ENEMY_VELOCITY
  end

  def move
    @y += @velocity
  end

  def draw
    @image.draw_rot(@x, @y, Configuration::Z_ENEMY)
  end
end

# The Bullet class
class Bullet
  attr_reader :x, :y

  def initialize(x, y)
    @image = Gosu::Image.new("#{__dir__}/images/laserBlue02.png")
    @x = x
    @y = y
    @velocity = Configuration::BULLET_VELOCITY
  end

  def move
    @y -= @velocity
  end

  def draw
    @image.draw_rot(@x, @y, Configuration::Z_BULLET)
  end
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

  def shoot
    Bullet.new(@x, @y - 50)
  end
end

# The Main Class
class SpaceShipWar < Gosu::Window
  def initialize
    super Configuration::WINDOW_WIDTH, Configuration::WINDOW_HEIGHT
    self.caption = "SpaceShip War"

    @player = Player.new(Configuration::WINDOW_WIDTH / 2, Configuration::WINDOW_HEIGHT - 100)
    @bullets = []
    @enemies = []
  end

  def update
    @player.move_left if Gosu.button_down? Gosu::KB_LEFT
    @player.move_right if Gosu.button_down? Gosu::KB_RIGHT
    @bullets.each(&:move)
    @enemies.each(&:move)

    check_collisions_bullets_enemies
    spawn_enemy if rand(100) < 4
  end

  def spawn_enemy
    enemy = Enemy.new(rand(Configuration::WINDOW_WIDTH), 0)
    @enemies.push(enemy)
  end

  def draw
    @player.draw
    @bullets.each(&:draw)
    @enemies.each(&:draw)
  end

  def button_down(button_id)
    case button_id
    when Gosu::KB_ESCAPE
      close
    when Gosu::KB_SPACE
      @bullets.push(@player.shoot)
    else
      super
    end
  end

  def check_collisions_bullets_enemies
    @bullets.each do |bullet|
      @enemies.each do |enemy|
        if Gosu.distance(bullet.x, bullet.y, enemy.x, enemy.y) < 30
          @enemies.delete(enemy)
          @bullets.delete(bullet)
        end
      end
    end
  end
end

SpaceShipWar.new.show
