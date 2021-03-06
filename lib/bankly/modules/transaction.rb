module Bankly
  class Transaction < Aux
    def initialize(log_requests = false)
      start_module(log_requests)
    end

    def payment_receipt(agency, account, authentication_code)
      response = @request.get("#{@url}/#{PAYMENT}/#{DETAIL}?bankBranch=#{agency}&bankAccount=#{account}&authenticationCode=#{authentication_code}", [json_header, api_v1_header, correlation_id], true)
    end

    def transfer_receipt(agency, account, authentication_code)
      response = @request.get("#{@url}/#{TRANSFER}/#{authentication_code}?branch=#{agency}&account=#{account}", [json_header, api_v1_header, correlation_id], true)
    end

  end
end