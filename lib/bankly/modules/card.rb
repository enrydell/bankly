module Bankly
  class Card < Aux
    def initialize
      start_module
    end

    def request_card(body)
      response = @request.postWithHeader("#{@url}/#{CARDS}/#{PHYSICAL}", body, [json_header, api_v1_header])
      card = Model.new(response)
      card
    end

    def get_card(proxy)
      response = @request.get("#{@url}/#{CARDS}/#{proxy}", [json_header, api_v1_header])
    end

    def activate_card(proxy, body)
      response = @request.patchWithHeader("#{@url}/#{CARDS}/#{proxy}/#{ACTIVATE}", body, [json_header, api_v1_header])
      card = Model.new(response)
      card
    end

    def validate_password(proxy, password)
      response = @request.postWithHeader("#{@url}/#{CARDS}/#{proxy}/#{PCI}", { password: password }, [json_header, api_v1_header])
      card = Model.new(response)
      card
    end

    def update_contactless_config(proxy, boolean)
      response = @request.patchWithHeader("#{@url}/#{CARDS}/#{proxy}/#{CONTACTLESS}?allowContactless=#{boolean}", {}, [json_header, api_v1_header])
      card = Model.new(response)
      card
    end
  end
end