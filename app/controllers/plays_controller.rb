class PlaysController < ApplicationController
  before_action :set_play, only: [:edit, :update, :destroy]

  # GET /plays
  # GET /plays.json
  def index
    @plays = Play.all
  end

  # GET /plays/1
  # GET /plays/1.json
  def show
    @game = Game.find(params[:id])
    if @game.state == "new"
        @game.state = "playing"
        @game.save
    end
    @play = Play.find(@game.play_id)
  end

  # GET /plays/new
  def new
    @play = Play.new
  end

  # GET /plays/1/edit
  def edit
  end

  # POST /plays
  # POST /plays.json
  def create
    @game = Game.find(params[:id])

    @play = Play.find(@game.play_id)
    @play.dart1 = params[:play]["dart1"]
    @play.dart2 = params[:play]["dart2"]
    @play.dart3 = params[:play]["dart3"]
    @play.save

    # сколько набранно очков за этот подход
    score = calc_table[params[:play]["dart1"]] + calc_table[params[:play]["dart2"]] + calc_table[params[:play]["dart3"]]

    # ищем какой игрок по счету сейчас бросал
    count = 0
    curr_pos = 0
    @game.players.split(',').map(&:to_i).each do |id|
      if id == @play.player
        curr_pos = count
      end
      count += 1
    end

    temp_score = @game.score.split(',').map(&:to_i)

    #если перед броском была возможность закрыться, увеличиваем счетчик попыток checkout
    if Checkout.find_by(points: temp_score[curr_pos])
      player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "checkout_total")
      player_stat.stat_value += 1
      player_stat.save
    end

    #вычисляем предварительный счет после броска
    temp_score[curr_pos] -= score

    #проверяем выполнены ли условия для закрытия
    game_over = 0
    if temp_score[curr_pos] == 0
      #finish_type == 1 - закрываться можно через любой сектор
      if (@game.finish_type & 0b00001) == 1
        game_over = 1
      #finish_type == 2 - закрываться можно через последний double
      elsif (@game.finish_type & 0b00010) >> 1 == 1
        if params[:play]["dart3"] =~ /^D\d+/
          game_over = 1
        end
      #finish_type == 4 - закрываться можно через последний triple
      elsif (@game.finish_type & 0b00100) >> 2 == 1
        if params[:play]["dart3"] =~ /^T\d+/
          game_over = 1
        end
      #finish_type == 8 - закрываться можно через double в любом броске
      elsif (@game.finish_type & 0b01000) >> 3 == 1
        if params[:play]["dart1"] + params[:play]["dart2"] + params[:play]["dart3"] =~ /D/
          game_over = 1
        end
      #finish_type == 16 - закрываться можно через triple в любом броске
      elsif (@game.finish_type & 0b10000) >> 4 == 1
        if params[:play]["dart1"] + params[:play]["dart2"] + params[:play]["dart3"] =~ /T/
          game_over = 1
        end
      end
    end

    #хорошие броски >59 и максимум записываем в статистику даже если при этом был перебор
    if score > 59
      if score < 100
        player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "points_60-99")
        player_stat.stat_value += 1
        player_stat.save
      elsif score < 140
        player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "points_100-139")
        player_stat.stat_value += 1
        player_stat.save
      elsif score < 180
        player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "points_140-179")
        player_stat.stat_value += 1
        player_stat.save
      else
        player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "points_180")
        player_stat.stat_value += 1
        player_stat.save
      end
    end
    player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "max_points")
    if player_stat.stat_value < score
      player_stat.stat_value = score
      player_stat.save
    end

    #считаем сколько было использовано дротиков и обновляем статистику по игре и по секторам
    total_darts = 0
    1.upto(3) do |count|
      #считаем только использованные дротики
      if params[:play]["dart#{count}"] != "unused"
        #остальную статистику ведем только для правильных бросков, без перебора
        if game_over == 1 || temp_score[curr_pos] > 1
          player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "sector_" + params[:play]["dart#{count}"])
          player_stat.stat_value += 1
          player_stat.save
          player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "#{count}dart_sum")
          player_stat.stat_value += calc_table[params[:play]["dart#{count}"]]
          player_stat.save
          player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "#{count}dart_throw")
          player_stat.stat_value += 1
          player_stat.save
          if params[:play]["dart#{count}"] == "miss"
            player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "#{count}dart_miss")
            player_stat.stat_value += 1
            player_stat.save
          end
        end
        total_darts += 1
      end
    end

    #в статистику по игре плюсуем все использованные дротики, а счет обновляем только если не было перебора
    stat = GamesStat.find_by(game_id: @game.id, player_id: @play.player)
    if game_over == 1 || temp_score[curr_pos] > 1
      stat.total_points += score
    end
    stat.total_darts += total_darts
    if score > stat.max_score
      stat.max_score = score
    end
    stat.save

    curr_leg = @play.num_leg
    curr_set = @play.num_set

    #если игрок закрылся
    if game_over == 1
      player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "checkout_success")
      player_stat.stat_value += 1
      player_stat.save
      player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "checkout_maximum")
      if score > player_stat.stat_value
        player_stat.stat_value = score
      end
      player_stat.save
      player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "checkout_sum")
      player_stat.stat_value += score
      player_stat.save
      player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "num_legs_won")
      player_stat.stat_value += 1
      player_stat.save
      @game.players.split(',').map(&:to_i).each do |id|
        player_stat = PlayerStat.find_by(player_id: id, stat_code: "num_legs")
        player_stat.stat_value += 1
        player_stat.save
      end
      if @game.num_legs == curr_leg
        if @game.num_sets == curr_set
          @game.state = "finished"
          @game.player_won = @play.player
          @game.save
          player_stat = PlayerStat.find_by(player_id: @play.player, stat_code: "num_sets_won")
          player_stat.stat_value += 1
          player_stat.save
          @game.players.split(',').map(&:to_i).each do |id|
            player_stat = PlayerStat.find_by(player_id: id, stat_code: "num_sets")
            player_stat.stat_value += 1
            player_stat.save
          end
          @game.score = temp_score.join(',')
          @game.save
          PaperTrail::Version.destroy_all
          redirect_to :controller => 'games', :action => 'index' and return
        else
          curr_leg = 1
          curr_set = @play.num_set + 1
          next_player = 0
        end
      else
        curr_leg += 1
        next_player = 0
      end
      @game.score = Array.new(@game.num_players, @game.points).join(',')
    else
      next_player = curr_pos + 1
      if next_player == @game.num_players
        next_player = 0
      end
      if temp_score[curr_pos] < 0 || temp_score[curr_pos] == 1
        temp_score[curr_pos] += score
      end
      @game.score = temp_score.join(',')
    end

    next_player_id = @game.players.split(',')[next_player].to_i

    new_play = Play.new
    new_play.game_id = @game.id
    new_play.num_set = curr_set
    new_play.num_leg = curr_leg
    new_play.turn = @play.turn + 1
    new_play.player = next_player_id
    new_play.dart1 = 0
    new_play.dart2 = 0
    new_play.dart3 = 0
    new_play.save

    @game.play_id = new_play.id
    @game.save

    redirect_to :controller => 'plays', :action => 'show', id: @game.id
  end

  def update

  end

  # DELETE /plays/1
  # DELETE /plays/1.json
  def destroy
    @play.destroy
    respond_to do |format|
      format.html { redirect_to plays_url, notice: 'Play was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def history
    @game = Game.find(params[:id])
  end

  def info_for_paper_trail
    { play_id: Play.last.id }
  end

  def undo
    Play.where("id >= ?", params[:play_id]).order('id DESC').each do |play|
      PaperTrail::Version.where(play_id: play.id).order('id DESC').each do |ver|
        if reify = ver.try(:reify)
          reify.save
        else
          ver.item.destroy
        end
      end
    end
    redirect_to :controller => 'plays', :action => 'show', id: params[:game_id]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_play
      @play = Play.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def play_params
      params.require(:play).permit(:game_id, :set, :leg, :turn, :player, :dart1, :dart2, :dart3)
    end

    def calc_table
      {
        "unused" => 0, "miss" => 0, "25" => 25, "50" => 50,
         "1"  => 1,  "2" => 2,  "3" => 3,  "4" => 4,  "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "10" => 10, "11" => 11, "12" => 12, "13" => 13, "14" => 14, "15" => 15, "16" => 16, "17" => 17, "18" => 18, "19" => 19, "20" => 20,
        "D1"  => 2, "D2" => 4, "D3" => 6, "D4" => 8, "D5" => 10, "D6" => 12, "D7" => 14, "D8" => 16, "D9" => 18, "D10" => 20, "D11" => 22, "D12" => 24, "D13" => 26, "D14" => 28, "D15" => 30, "D16" => 32, "D17" => 34, "D18" => 36, "D19" => 38, "D20" => 40,
        "T1"  => 3, "T2" => 6, "T3" => 9, "T4" => 12, "T5" => 15, "T6" => 18, "T7" => 21, "T8" => 24, "T9" => 27, "T10" => 30, "T11" => 33, "T12" => 36, "T13" => 39, "T14" => 42, "T15" => 45, "T16" => 48, "T17" => 51, "T18" => 54, "T19" => 57, "T20" => 60
      }
    end
end
