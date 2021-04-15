module Bankly
  class Address < Aux
    def initialize(log_requests = false)
      start_module(log_requests)
    end

    def check_zip(zip)
      response = @request.get("https://viacep.com.br/ws/#{zip.gsub(/[^0-9]/, '')}/json/")
      address = Model.new(response)
      address
    end
  end
end