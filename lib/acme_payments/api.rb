# frozen_string_literal: true

require 'net/http'

module AcmePayments
  module Api
    extend self
    
    URL = "https://api-engine-dev.clerq.io/tech_assessment"

    def list_customers(**params)
      list_with_pagination(route: "/customers/", params:).then do |results|
        map_results_to_model(model: Models::Customer, results:)
      end
    end

    def list_merchants(**params)
      list_with_pagination(route: "/merchants/", params:).then do |results|
        map_results_to_model(model: Models::Merchant, results:)
      end
    end

    def list_orders(**params)
      list_with_pagination(route: "/orders/", params:).then do |results|
        map_results_to_model(model: Models::Order, results:)
      end
    end

    def list_transactions(**params)
      list_with_pagination(route: "/transactions/", params:).then do |results|
        map_results_to_model(model: Models::Transaction, results:)
      end
    end

    private

    def list_with_pagination(route:, params:)
      results = []
      uri = URI(URL + route)
      uri.query = URI.encode_www_form(params)

      result = fetch_with_retry(uri:)
      results += result['results']

      # Handle pagination
      while result['next']
        result = fetch_with_retry(uri: URI(result['next']))
        results += result['results']
      end

      results
    end

    def fetch_with_retry(uri:, num_of_retries: 5)
      response = Net::HTTP::get_response(uri)
      return JSON.parse(response.body) if response.instance_of? Net::HTTPOK
      
      # Retry logic
      retry_count = num_of_retries - 1
      raise StandardError, "Out of retries" if retry_count <= 0
      fetch_with_retry(uri:, num_of_retries: retry_count)
    end

    def map_results_to_model(model:, results:)
      results.map{ |res| model.new(**res.transform_keys(&:to_sym)) }
    end
  end
end