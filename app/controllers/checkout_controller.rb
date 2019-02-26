class CheckoutController < ApplicationController
  def show
    valid_checkout = []
    if params[:points].to_i < 181
      sector_stat = PlayerStat.where('player_id == ? AND stat_code LIKE ?', params[:player_id].to_i, 'sector_%')
      stat_hash = {}
      sector_stat.each do |r|
        if r.stat_code =~ /sector_(miss|[DT]?[0-9]+)/
          stat_hash[$1] = r.stat_value
        end
      end

      possible_checkout = []
      calc_table.each do |dart1, cost1|
        if params[:num_darts].to_i > 1 && params[:points].to_i-cost1 < 121
          calc_table.each do |dart2, cost2|
            if params[:num_darts].to_i > 2 && params[:points].to_i-cost1-cost2 < 61
              calc_table.each do |dart3, cost3|
                if cost1+cost2+cost3 == params[:points].to_i
                  possible_checkout.push([dart1+" "+dart2+" "+dart3, stat_hash[dart1]+stat_hash[dart2]+stat_hash[dart3]])
                end
              end
            else
              if cost1+cost2 == params[:points].to_i
                possible_checkout.push([dart1+" "+dart2, stat_hash[dart1]+stat_hash[dart2]])
              end
            end
          end
        else
          if cost1 == params[:points].to_i
            possible_checkout.push([dart1, stat_hash[dart1]])
          end
        end
      end

      max_sum = 0
      possible_checkout.each do |item|
        game_over = 0
        #finish_type == 1 - закрываться можно через любой сектор
        if (params[:finish_type].to_i & 0b00001) == 1
          game_over = 1
        end
        #finish_type == 2 - закрываться можно через последний double
        if (params[:finish_type].to_i & 0b00010) >> 1 == 1
          if item[0] =~ /(D\d+|50)(unused|miss)*$/
            game_over = 1
          end
        end
        #finish_type == 4 - закрываться можно через последний triple
        if (params[:finish_type].to_i & 0b00100) >> 2 == 1
          if item[0] =~ /(T\d+)(unused|miss)*$/
            game_over = 1
          end
        end
        #finish_type == 8 - закрываться можно через double в любом броске
        if (params[:finish_type].to_i & 0b01000) >> 3 == 1
          if item[0] =~ /(D\d+|50)/
            game_over = 1
          end
        end
        #finish_type == 16 - закрываться можно через triple в любом броске
        if (params[:finish_type].to_i & 0b10000) >> 4 == 1
          if item[0] =~ /T\d+/
            game_over = 1
          end
        end
        if game_over == 1
          if item[1] >= max_sum
            if item[1] > max_sum
              valid_checkout = []
              max_sum = item[1]
            end
            valid_checkout.push(item[0])
          end
        end
      end
    end
    valid_checkout.push("NA")
    render json: {"points": params[:points].to_i, "combination": valid_checkout[0], num_darts: 0}
  end

  private
  def calc_table
    {
      "miss" => 0, "25" => 25, "50" => 50,
       "1"  => 1,  "2" => 2,  "3" => 3,  "4" => 4,  "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "10" => 10, "11" => 11, "12" => 12, "13" => 13, "14" => 14, "15" => 15, "16" => 16, "17" => 17, "18" => 18, "19" => 19, "20" => 20,
      "D1"  => 2, "D2" => 4, "D3" => 6, "D4" => 8, "D5" => 10, "D6" => 12, "D7" => 14, "D8" => 16, "D9" => 18, "D10" => 20, "D11" => 22, "D12" => 24, "D13" => 26, "D14" => 28, "D15" => 30, "D16" => 32, "D17" => 34, "D18" => 36, "D19" => 38, "D20" => 40,
      "T1"  => 3, "T2" => 6, "T3" => 9, "T4" => 12, "T5" => 15, "T6" => 18, "T7" => 21, "T8" => 24, "T9" => 27, "T10" => 30, "T11" => 33, "T12" => 36, "T13" => 39, "T14" => 42, "T15" => 45, "T16" => 48, "T17" => 51, "T18" => 54, "T19" => 57, "T20" => 60
    }
  end
end
