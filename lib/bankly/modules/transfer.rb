module Bankly
  class Transfer < Aux

    def initialize
      start_module
    end

    def list_banks
      response = @request.get("#{@url}/#{BANKLIST}", [json_header, api_v1_header], true)
    end

    def execute(body)
      response = @request.postWithHeader("#{@url}/#{TRANSFER}", body, [json_header, api_v1_header, correlation_id])
      transfer = Model.new(response)
      transfer
    end
  end
end