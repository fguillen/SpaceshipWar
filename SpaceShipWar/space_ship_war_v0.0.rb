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
  Z_EXPLOSION = 3
  Z_UI = 4
end

class LaserFlash
  @all = []

  class << self
    attr_accessor :all
  end

  def initialize(x, y)
    @animation = [Gosu::Image.new("#{__dir__}/images/laserBlue10.png"), Gosu::Image.new("#{__dir__}/images/laserBlue11.png")]
    @x = x
    @y = y
    @animation_frame = -1
    next_frame

    LaserFlash.all.push(self)
  end

  def update
    next_frame if Gosu.milliseconds >= @animation_next_frame_at
  end

  def next_frame
    @animation_frame += 1
    @animation_next_frame_at = Gosu.milliseconds + 80

    if @animation_frame >= @animation.length
      die
    else
      @image = @animation[@animation_frame]
    end
  end

  def die
    LaserFlash.all.delete(self)
  end

  def draw
    @image.draw_rot(@x, @y, Configuration::Z_EXPLOSION)
  end
end

class Explosion
  @all = []

  class << self
    attr_accessor :all
  end

  def initialize(x, y)
    @animation = [Gosu::Image.new("#{__dir__}/images/laserBlue08.png"), Gosu::Image.new("#{__dir__}/images/laserBlue09.png")]
    @x = x
    @y = y
    @animation_frame = -1
    next_frame

    Explosion.all.push(self)
  end

  def update
    next_frame if Gosu.milliseconds >= @animation_next_frame_at
  end

  def next_frame
    @animation_frame += 1
    @animation_next_frame_at = Gosu.milliseconds + 100

    if @animation_frame >= @animation.length
      die
    else
      @image = @animation[@animation_frame]
    end
  end

  def die
    Explosion.all.delete(self)
  end

  def draw
    @image.draw_rot(@x, @y, Configuration::Z_EXPLOSION)
  end
end

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
    Bullet.new(@x, @y - 40)
    LaserFlash.new(@x, @y - 40)
  end
end

# The Main Class
class SpaceShipWar < Gosu::Window
  def initialize
    super Configuration::WINDOW_WIDTH, Configuration::WINDOW_HEIGHT
    self.caption = "SpaceShip War"

    @player = Player.new(Configuration::WINDOW_WIDTH / 2, Configuration::WINDOW_HEIGHT - 100)
    @enemies = []

    @clip_shot = Gosu::Sample.new("#{__dir__}/sounds/sfx_laser1.ogg")
    @clip_explosion = Gosu::Sample.new("#{__dir__}/sounds/explosionCrunch_000.ogg")
  end

  def update
    player_move
    actors_updates

    check_collisions_bullets_enemies
    spawn_enemy if rand(100) < 4
  end

  def player_move
    @player.move_left if Gosu.button_down? Gosu::KB_LEFT
    @player.move_right if Gosu.button_down? Gosu::KB_RIGHT
  end

  def actors_updates
    Bullet.all.each(&:update)
    Enemy.all.each(&:update)
    Explosion.all.each(&:update)
    LaserFlash.all.each(&:update)
  end

  def spawn_enemy
    Enemy.new(rand(Configuration::WINDOW_WIDTH), 0)
  end

  def draw
    @player.draw
    Bullet.all.each(&:draw)
    Enemy.all.each(&:draw)
    Explosion.all.each(&:draw)
    LaserFlash.all.each(&:draw)
  end

  def button_down(button_id)
    case button_id
    when Gosu::KB_ESCAPE
      close
    when Gosu::KB_SPACE
      @player.shoot
      @clip_shot.play
    else
      super
    end
  end

  def check_collisions_bullets_enemies
    Bullet.all.each do |bullet|
      Enemy.all.each do |enemy|
        enemy_destroyed(enemy, bullet) if Gosu.distance(bullet.x, bullet.y, enemy.x, enemy.y) < 30
      end
    end
  end

  def enemy_destroyed(enemy, bullet)
    enemy.destroy
    bullet.destroy

    Explosion.new(enemy.x, enemy.y)
    @clip_explosion.play
  end
end

SpaceShipWar.new.show
