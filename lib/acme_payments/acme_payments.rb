# frozen_string_literal: true

module AcmePayments
  VERSION = "1.0.0"
end

# Import models
require "acme_payments/models/customer"
require "acme_payments/models/merchant"
require "acme_payments/models/order"
require "acme_payments/models/transaction"
require "acme_payments/api"
require "acme_payments/calculate_settlement"

# Standardize time to UTC
require "active_support"
Time.zone = 'UTC'