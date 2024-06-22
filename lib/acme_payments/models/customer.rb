# frozen_string_literal: true

module AcmePayments
  module Models
    Customer = Data.define(
      :id,
      :created_at,
      :updated_at,
      :first_name,
      :last_name,
      :phone,
      :address,
      :email
    ) do
      # 'address' is a nullable field according to the API docs
      def initialize(address: nil, **args)
        super(address: nil, **args)
      end
    end
  end
end