class CheckoutController < ApplicationController
  def show
    if checkout = Checkout.find_by(points: params[:points])
      num_darts = checkout.combination.split(' ').length
      if num_darts <= params[:num_darts].to_i
        render json: {"points": params[:points].to_i, "combination": checkout.combination, num_darts: num_darts}
        return
      end
    end
    render json: {"points": params[:points].to_i, "combination": "NA", num_darts: 0}
  end
end
