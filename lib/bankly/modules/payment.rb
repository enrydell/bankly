module Bankly
  class Payment < Aux
    def initialize
      start_module
    end

    def validate(barcode)
      response = @request.postWithHeader("#{@url}/#{PAYMENT}/#{VALIDATE}", { code: barcode }, [json_header, api_v1_header])
      invoice = Model.new(response)
      invoice
    end

    def pay(id, agency, account, amount, desc = '')
      response = @request.postWithHeader("#{@url}/#{PAYMENT}/#{CONFIRM}", { id: id, bankBranch: agency, bankAccount: account, amount: amount, description: desc }, [json_header, api_v1_header])
      invoice = Model.new(response)
      invoice
    end
  end
end