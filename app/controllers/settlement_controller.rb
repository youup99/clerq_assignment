# frozen_string_literal: true

class SettlementController < ApplicationController
  def index
    merchant = params["merchant"]
    date = params["date"]
    @settlement = AcmePayments::CalculateSettlement.execute(merchant_info: merchant, date:)
    render json: @settlement # Comment this out to see HTML result in the browser
  end
end