# frozen_string_literal: true

module AcmePayments
  module Models
    Merchant = Data.define(
      :id,
      :created_at,
      :updated_at,
      :name
    )
  end 
end