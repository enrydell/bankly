module Bankly
  class Events < Aux

    def initialize(log_requests = false)
      start_module(log_requests)
    end

    def get_events(query)
      response = @request.get("#{@url}/#{EVENTS}#{Helper.json_to_url_params(query)}", [json_header, api_v1_header, correlation_id])
    end
  end
end