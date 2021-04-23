require "gosu"
require_relative "configuration"
require_relative "laser_flash"
require_relative "explosion"
require_relative "enemy"
require_relative "bullet"
require_relative "player"
require_relative "enemy_spawner"

# The Main Class
class Game < Gosu::Window
  def initialize
    super Configuration::WINDOW_WIDTH, Configuration::WINDOW_HEIGHT
    self.caption = "SpaceShip War"

    @player = Player.new(Configuration::WINDOW_WIDTH / 2, Configuration::WINDOW_HEIGHT - 100)
    @enemies = []
    @enemy_spawner = EnemySpawner.new

    @clip_shot = Gosu::Sample.new("#{__dir__}/sounds/sfx_laser1.ogg")
    @clip_explosion = Gosu::Sample.new("#{__dir__}/sounds/explosionCrunch_000.ogg")
  end

  def update
    player_move
    actors_updates

    check_collisions_bullets_enemies

    @enemy_spawner.update
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

Game.new.show
