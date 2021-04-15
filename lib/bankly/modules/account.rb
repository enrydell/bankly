module Bankly
  class Account < Aux

    def initialize(log_requests = false)
      start_module(log_requests)
    end

    def create_person(document_number, body)
      response = @request.put("#{@url}/#{CUSTOMERS}/#{document_number.gsub(/[^0-9]/, '')}", body, [json_header, api_v1_header])
      person = Model.new(response)
      person
    end

    def update_person(document_number, body)
      response = @request.patch("#{@url}/#{CUSTOMERS}/#{document_number.gsub(/[^0-9]/, '')}", body, [json_header, api_v1_header])
      person = Model.new(response)
      person
    end

    def get_person(document_number)
      response = @request.get("#{@url}/#{CUSTOMERS}/#{document_number.gsub(/[^0-9]/, '')}", [json_header, api_v1_header])
      person = Model.new(response)
      person
    end

    def send_document(document_number, opts)
      opts[:headers] = {
        'Accept' => 'application/json',
        'api-version' => '1.0'
      }
      response = @request.putBinary("#{@url}/#{DOCUMENT}/#{document_number.gsub(/[^0-9]/, '')}", opts)
      document = Model.new(response)
      document
    end

    def get_files_statuses(document_number, file_tokens)
      response = @request.get("#{@url}/#{DOCUMENT}/#{document_number.gsub(/[^0-9]/, '')}?resultLevel=DETAILED&#{file_tokens}", [json_header, api_v1_header], true)
    end

    def create_bank_account(document_number, account_type = 'PAYMENT_ACCOUNT')
      response = @request.postWithHeader("#{@url}/#{CUSTOMERS}/#{document_number.gsub(/[^0-9]/, '')}/#{ACCOUNTS}", { accountType: account_type }, [json_header, api_v1_header])
      account = Model.new(response)
      account
    end

    def get_bank_account(document_number)
      response = @request.get("#{@url}/#{CUSTOMERS}/#{document_number.gsub(/[^0-9]/, '')}/#{ACCOUNTS}", [json_header, api_v1_header], true)
    end

    def get_account_balance(bank_number)
      response = @request.get("#{@url}/#{ACCOUNTS}/#{bank_number.gsub(/[^0-9]/, '')}?includeBalance=true", [json_header, api_v1_header], true)
    end

    def get_account_statements(bank_agency, bank_number, offset, limit = 20, details = 'true')
      response = @request.get("#{@url}/#{ACCOUNT}/#{STATEMENT}?branch=#{bank_agency}&account=#{bank_number}&offset=#{offset}&limit=#{limit}&details=#{details}",
                              [json_header, api_v1_header])
    end

  end
end