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

    def get_deposit_slip_data(branch, account, authentication_code)
      response = @request.get("#{@url}/#{BANKSLIP}/#{BRANCH}/#{branch}/#{NUMBER}/#{account}/#{authentication_code}", [json_header, api_v1_header], true)
    end
  end
end