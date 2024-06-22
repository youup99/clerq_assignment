# frozen_string_literal: true

module AcmePayments
  module Models
    Transaction = Data.define(
      :id,
      :created_at,
      :updated_at,
      :amount,
      :type,
      :customer,
      :merchant,
      :order
    )
  end
end