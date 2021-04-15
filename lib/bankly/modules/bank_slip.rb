module Bankly
  class BankSlip < Aux
    def initialize(log_requests = false)
      start_module(log_requests)
    end

    def generate(body)
      response = @request.postWithHeader("#{@url}/#{BANKSLIP}", body, [json_header, api_v1_header])
      bank_slip = Model.new(response)
      bank_slip
    end

    def get_slip_data(branch, account, authentication_code)
      response = @request.get("#{@url}/#{BANKSLIP}/#{BRANCH}/#{branch}/#{NUMBER}/#{account}/#{authentication_code}", [json_header, api_v1_header], true)
    end
    
    def get_slip_pdf(authentication_code)
      response = @request.get("#{@url}/#{BANKSLIP}/#{authentication_code}/#{PDF}", [json_header, api_v1_header], true)
    end

    def cancel_slip(branch, account, authentication_code)
      response = @request.delete("#{@url}/#{BANKSLIP}/#{cancel}", { authenticationCode: authentication_code, account: { number: account, branch: branch } }, [json_header, api_v1_header])
      bank_slip = Model.new(response)
      bank_slip
    end
  end
end