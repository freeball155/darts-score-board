class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
  end

  def index
    @games = Game.all
  end

  def new
    @players = Player.all
  end

  def create
    game = Game.new
    game.num_legs = params[:game]["num_legs"]
    game.num_sets = params[:game]["num_sets"]
    game.players = params[:game]["players"].join(',')
    game.num_players = params[:game]["players"].count
    game.state = 'new'
    game.game_type = params[:game]["game_type"]
    game.points =  params[:game]["points"]
    game.score = Array.new(game.num_players, params[:game]["points"]).join(',')
    game.finish_type = params[:game]["finish_type"].map(&:to_i).sum
    game.player_won = 0
    game.save

    play = Play.new
    play.game_id = game.id
    play.num_set = 1
    play.num_leg = 1
    play.turn = 1
    play.player = params[:game]["players"].first
    play.dart1 = 0
    play.dart2 = 0
    play.dart3 = 0
    play.save

    game.play_id = play.id
    game.save

    params[:game]["players"].each do |id|
      stat = GamesStat.new
      stat.game_id = game.id
      stat.player_id = id
      stat.total_points = 0
      stat.total_darts = 0
      stat.max_score = 0
      stat.save
    end

    redirect_to :controller => 'games', :action => 'show', :id => game.id
  end

  def destroy
    @game = Game.find(params[:id])
    GamesStat.where(game_id: @game.id).delete_all
    Play.where(game_id: @game.id).delete_all
    @game.destroy

    redirect_to :controller => 'games', :action => 'index'
  end

  def sorting
    game = Game.find(params[:id])
    new_order = game.players.split(',').shuffle
    game.players = new_order.join(',')
    game.save
    play = Play.find_by(game_id: game.id)
    play.player = new_order[0].to_i
    play.save
    
    redirect_to :controller => 'games', :action => 'show', :id => params[:id]
  end
end
