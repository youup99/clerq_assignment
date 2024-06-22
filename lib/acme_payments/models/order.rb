# frozen_string_literal: true

module AcmePayments
  module Models
    Order = Data.define(
      :id,
      :transactions,
      :created_at,
      :updated_at,
      :type,
      :items_data,
      :total_amount,
      :trace_id,
      :parent_order,
      :customer,
      :merchant
    ) do
      # 'parent_order' is a nullable field according to the API docs
      def initialize(parent_order: nil, **args)
        super(parent_order:, **args)
      end
    end
  end
end