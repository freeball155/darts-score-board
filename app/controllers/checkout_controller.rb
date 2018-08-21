class CheckoutController < ApplicationController
  def show
    if checkout = Checkout.find_by(points: params[:id])
      num_darts = checkout.combination.split(' ').length
      render json: {"points": params[:id].to_i, "combination": checkout.combination, num_darts: num_darts}
    else
      render json: {"points": params[:id].to_i, "combination": "NA", num_darts: 0}
    end
  end
end
