# frozen_string_literal: true

module AcmePayments
  module CalculateSettlement
    extend self
    
    def execute(merchant_info:, date:)
      current_merchant = find_current_merchant(merchant_info:)
      raise StandardError if current_merchant.nil?

      date_range = date_range(date:)
      transactions = Api.list_transactions(merchant: current_merchant.id, **date_range)
      settlement_amount = calculate_settlement(transactions:)
      
      {
        merchant: {id: current_merchant.id, name: current_merchant.name},
        date_range: date_range,
        settlement_amount:,
        transaction_ids: transactions.map(&:id),
        transaction_count: transactions.size
      }
    end

    private

    def calculate_settlement(transactions:)
      total = 0;
      transactions.map do |txn|
        txn_amount = txn.amount
        case txn.type
        when "PURCHASE", "SALE" # Not listed in PaymentTypeEnum but see it in the list of transactions
          total += txn_amount.to_f
        when "REFUND"
          total -= txn_amount.to_f
        else
          raise StandardError, "Unknown transaction type: #{txn.type}"
        end
      end
      
      total.to_f.round(2)
    end

    def current_merchants
      @current_merchants ||= begin
        timestamp = Time.current.to_fs(:iso8601)
        merchant_list = Api.list_merchants(created_at__lte: timestamp)
        {timestamp:, merchant_list:}
      end
    end

    def transactions
      Api.list_transactions(merchant: merchant.id, **window)
    end

    def find_current_merchant(merchant_info:)
      current_merchants[:merchant_list].find{ |m| m.name == merchant_info || m.id == merchant_info }
    end

    def date_range(date:)
      date = Date.parse(date)

      # My best effort to support Friday
      # Edge cases are holidays - how do we handle those?
      raise StandardError if date.saturday? || date.sunday?
      
      if date.monday?
        start = date - 3.days
      else
        start = date.yesterday
      end

      if start.friday?
        greater_than_time = start.to_time(:utc).change(hour: 17)
      else
        greater_than_time = date.beginning_of_day
      end

      if date.friday?
        less_than_or_equal_time = date.to_time(:utc).change(hour: 17)
      else
        less_than_or_equal_time = date.end_of_day
      end

      # ISO 8601 !
      {
        created_at__gt: greater_than_time.to_fs(:iso8601),
        created_at__lte: less_than_or_equal_time.to_fs(:iso8601),
      }
    end
  end
end