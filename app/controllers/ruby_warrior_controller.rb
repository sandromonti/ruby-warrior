class RubyWarriorController < ApplicationController
  def index
  end

  def board
    RubyWarrior::Config.path_prefix = 'C:/Users/Sandro/Documents/ruby-warrior/rubywarrior/sandro-beginner'
    @@game = RubyWarrior::Game.new
    @@game.start
    @@warrior_position = 0
  end

  def get_available_abilities
    return "ABILITIES"
  end

  def move_spartacus
    false unless @@warrior_position < @@game.current_level.warrior_position
    @@warrior_position = @@game.current_level.warrior_position
  end

  def verify_move
    respond_to do |format|
      format.html
      if move_spartacus
        format.json {render json: true}
      else
        format.json {render json: false}
      end
    end
  end

end
