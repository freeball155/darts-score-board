class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def show
    @player = Player.find(params[:id])
  end

  def new
  end

  def create
    @player = Player.new(params.require(:player).permit(:name))
    @player.save


    default_stat_code.each do |stat_code|
      player_stat = PlayerStat.new()
      player_stat.player_id = @player.id
      player_stat.stat_code = stat_code
      player_stat.stat_value = 0
      player_stat.save
    end

    redirect_to @player
  end

  def destroy
    @player = Player.find(params[:id])
    PlayerStat.where(player_id: @player.id).delete_all
    @player.destroy

    redirect_to :controller => 'players', :action => 'index'
  end

  private
    def default_stat_code
      [
        'sector_miss', 'sector_25', 'sector_50',
        'sector_1', 'sector_2', 'sector_3', 'sector_4', 'sector_5', 'sector_6', 'sector_7', 'sector_8', 'sector_9', 'sector_10', 'sector_11', 'sector_12', 'sector_13', 'sector_14', 'sector_15', 'sector_16', 'sector_17', 'sector_18', 'sector_19', 'sector_20',
        'sector_D1', 'sector_D2', 'sector_D3', 'sector_D4', 'sector_D5', 'sector_D6', 'sector_D7', 'sector_D8', 'sector_D9', 'sector_D10', 'sector_D11', 'sector_D12', 'sector_D13', 'sector_D14', 'sector_D15', 'sector_D16', 'sector_D17', 'sector_D18', 'sector_D19', 'sector_D20',
        'sector_T1', 'sector_T2', 'sector_T3', 'sector_T4', 'sector_T5', 'sector_T6', 'sector_T7', 'sector_T8', 'sector_T9', 'sector_T10', 'sector_T11', 'sector_T12', 'sector_T13', 'sector_T14', 'sector_T15', 'sector_T16', 'sector_T17', 'sector_T18', 'sector_T19', 'sector_T20',
        'checkout_total',
	      'checkout_success',
        'chekout_maximum',
        'checkout_sum',
	      '1dart_sum',
	      '1dart_miss',
      	'1dart_throw',
      	'2dart_sum',
      	'2dart_miss',
      	'2dart_throw',
      	'3dart_sum',
      	'3dart_miss',
      	'3dart_throw',
      	'num_legs',
      	'num_sets',
      	'num_legs_won',
      	'num_sets_won',
      	'max_points',
        'points_60-99',
        'points_100-139',
        'points_140-179',
        'points_180'
      ]
    end
end
