module Bankly
  class BankSlip < Aux
    def initialize
      start_module
    end

    def generate_deposit(body)
      response = @request.postWithHeader("#{@url}/#{BANKSLIP}", body, [json_header, api_v1_header])
      bank_slip = Model.new(response)
      bank_slip
    end
  end
end