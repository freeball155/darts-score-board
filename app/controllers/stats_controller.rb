class StatsController < ApplicationController
  def topn
  end

  def players
  end

  def heatmap
    #outer radiuses of each zones
    sec_radius = {'bull': 10.5, '25': 25, 'inner': 145, 'T': 160, 'outer': 238, 'D': 253}
    #sectors order and angles starting from 6 clockwise
    sec_angle = {
       '6' => 0,
      '10' => 18,
      '15' => 36,
       '2' => 54,
      '17' => 72,
       '3' => 90,
      '19' => 108,
       '7' => 126,
      '16' => 144,
       '8' => 162,
      '11' => 180,
      '14' => 198,
       '9' => 216,
      '12' => 234,
       '5' => 252,
      '20' => 270,
       '1' => 288,
      '18' => 306,
       '4' => 324,
      '13' => 342
    }
    if sector_stat = PlayerStat.where('player_id == ? AND stat_code LIKE ?', params[:id], 'sector_%')
      result = []
      min = 0
      max = 0
      sector_stat.each do |r|
        max = [r.stat_value, max].max
        min = [r.stat_value, min].min
        if r.stat_code == 'sector_miss'
          rad = 320
          angle = 0
          logger.debug params[:miss_matter]
          if params[:miss_matter] == "1"
            count = 20
          else
            count = 0
          end
          radius = 100
        elsif r.stat_code =~ /sector_([DT]?)([0-9]+)/
          case $1
            when 'D'
              rad = 245 #doubles
              angle = 2 * Math::PI * sec_angle[$2] / 360
              count = 1
              radius = 50
            when 'T'
              rad = 152 #triples
              angle = 2 * Math::PI * sec_angle[$2] / 360
              count = 1
              radius = 50
            when 'miss'

          end
          case $2
            when '25'
                rad = 17.5
                angle = 0
                count = 8
                radius = 20
              when '50'
                rad = 0
                angle = 0
                count = 1
                radius = 10
              else
                if not $1.in?(['D','T'])
                rad = 199;
                angle = 2 * Math::PI * sec_angle[$2] / 360
                count = 1
                radius = 100
              end

          end
        end
        count.times do |index|
          curr_angle = angle + 2 * Math::PI * index / count
          x = (rad*Math.cos(curr_angle) + 375).round
          y = (rad*Math.sin(curr_angle) + 375).round
          result.push({"sector": r.stat_code, "x": x, "y": y, "value": r.stat_value, "radius": radius, "index": index})
        end
      end
      render json: {'min': min, 'max': max, 'data': result}
    end
  end
end
