class Game < ApplicationRecord
#  has_many :games_stats
  has_paper_trail ignore: [:state]
end
