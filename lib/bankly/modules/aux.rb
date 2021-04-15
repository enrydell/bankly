module Bankly
  
  class Aux
    
    def start_module(log_requests)
      Auth.login
      
      @request = Request.new(log_requests)

      @url = Rails.env.eql?('development') || Rails.env.eql?('homologation') ? URL_HML : URL_PROD
    end

    def json_header
      { key: 'Content-Type', value: 'application/json' }
    end

    def api_v1_header
      { key: 'api-version', value: '1.0' }
    end

    def correlation_id
      { key: 'x-correlation-id', value: SecureRandom.uuid }
    end

  end

  module Auth

    def self.login
      if Auth.should_refresh_token?
        client_id = 'e3b2bf48-a3d9-4e9d-b540-b3707a67d0a4'
        client_secret = 'e0c6282b-3e1f-40c0-8190-dd2a6d9c0166'

        url = Rails.env.eql?('development') || Rails.env.eql?('homologation') ? LOGIN_HML : LOGIN_PROD

        puts url
        request = Request.new(false, {
          'Content-Type' => 'application/x-www-form-urlencoded'
        })
        response = request.post("#{url}/#{TOKEN_PATH}", {
          grant_type: 'client_credentials',
          client_id: client_id,
          client_secret: client_secret
        })

        token = Model.new(response)
        p token

        Auth.save_token(token[:content]['access_token'])
      end
    end

    def self.save_token(token)
			if !token.nil?
				ENV['BANKLY_TOKEN'] = "Bearer #{token.to_s}"
				ENV['BANKLY_TOKEN_EXPIRY'] = (Time.now + 3600).to_s
			end
    end

    def self.should_refresh_token?
			finish_date = ENV['BANKLY_TOKEN_EXPIRY']
			finish_date.nil? || (Time.parse(finish_date.to_s) - 500) < Time.now
		end

  end

  class Request
    require 'httparty'
    require 'json'
    require 'ostruct'
    require 'uri'

    def initialize(log_requests, headers = nil)
      unless headers.nil?
        @headers = headers
      else
        @headers = {}
        @headers['Authorization'] = ENV['BANKLY_TOKEN']
      end

      @log_requests = log_requests
    end

    def post(url, body, use_json = false)
      puts url.to_s
      if use_json
        @headers['Content-Type'] = 'application/json'
      end
      if @headers['Content-Type'].eql?('application/x-www-form-urlencoded')
        body = URI.encode_www_form(body)
      else
        body = body.to_json
      end

      unless @log_requests
        req = HTTParty.post(url, body: body, headers: @headers)
      else
        req = HTTParty.post(url, body: body, headers: @headers, debug_output: $stdout)
      end

      valid_response(req)
    end

    def postBinary(url, options = {})
      puts url.to_s
      body = options[:body].nil? ? {} : options[:body]
      headers = options[:headers].nil? ? {} : options[:headers]

      headers['Authorization'] = @headers['Authorization']

      unless @log_requests
        req = HTTParty.post(url, body: body, headers: headers)
      else
        req = HTTParty.post(url, body: body, headers: headers, debug_output: $stdout)
      end

      valid_response(req)
    end

    def postWithHeader(url, body, headers = [])
      puts url.to_s
      if headers.length > 0
        headers.each do |header|
          if !header[:key].nil? && !header[:value].nil?
            @headers[header[:key]] = header[:value]
          end
        end
      end

      if @headers['Content-Type'].eql?('application/x-www-form-urlencoded')
        body = URI.encode_www_form(body)
      else
        body = body.to_json
      end

      unless @log_requests
        req = HTTParty.post(url, body: body, headers: @headers)
      else
        req = HTTParty.post(url, body: body, headers: @headers, debug_output: $stdout)
      end

      valid_response(req)
    end

    def put(url, body = {}, headers = [])
      puts url.to_s
      if headers.length > 0
        headers.each do |header|
          @headers[header[:key]] = header[:value]
        end
      end

      unless @log_requests
        req = HTTParty.put(url, headers: @headers, body: body.to_json)
      else
        req = HTTParty.put(url, headers: @headers, body: body.to_json, debug_output: $stdout)
      end
      
      valid_response(req)
    end

    def putBinary(url, options = {})
      puts url.to_s
      body = options[:body].nil? ? {} : options[:body]
      headers = options[:headers].nil? ? {} : options[:headers]

      headers['Authorization'] = @headers['Authorization']

      unless @log_requests
        req = HTTParty.put(url, body: body, headers: headers)
      else
        req = HTTParty.put(url, body: body, headers: headers, debug_output: $stdout)
      end

      valid_response(req)
    end

    def get(url, headers = [], skipValidation = false, follow_redirects = true)
      puts url.to_s
      if headers.length > 0
        headers.each do |header|
          if !header[:key].nil? && !header[:value].nil?
            @headers[header[:key]] = header[:value]
          end
        end
      end

      unless @log_requests
        req = HTTParty.get(url, headers: @headers, follow_redirects: follow_redirects)
      else
        req = HTTParty.get(url, headers: @headers, follow_redirects: follow_redirects, debug_output: $stdout)
      end

      return req unless follow_redirects

      if skipValidation
        req.parsed_response
      else
        valid_response(req)
      end
    end

    def patch(url, body = {}, headers = [])
      puts url.to_s
      if headers.length > 0
        headers.each do |header|
          @headers[header[:key]] = header[:value]
        end
      end

      unless @log_requests
        req = HTTParty.patch(url, headers: @headers, body: body.to_json)
      else
        req = HTTParty.patch(url, headers: @headers, body: body.to_json, debug_output: $stdout)
      end
      
      valid_response(req)
    end

    def patchWithHeader(url, body, headers = [])
      puts url.to_s
      if headers.length > 0
        headers.each do |header|
          if !header[:key].nil? && !header[:value].nil?
            @headers[header[:key]] = header[:value]
          end
        end
      end

      if @headers['Content-Type'].eql?('application/x-www-form-urlencoded')
        body = URI.encode_www_form(body)
      else
        body = body.to_json
      end

      unless @log_requests
        req = HTTParty.patch(url, body: body, headers: @headers)
      else
        req = HTTParty.patch(url, body: body, headers: @headers, debug_output: $stdout)
      end
      
      valid_response(req)
    end

    def delete(url, body = {}, headers = [])
      if headers.length > 0
        headers.each do |header|
          @headers[header[:key]] = header[:value]
        end
      end
      
      if body.nil?
        unless @log_requests
          req = HTTParty.delete(url, headers: @headers)
        else
          req = HTTParty.delete(url, headers: @headers, debug_output: $stdout)
        end
      else
        unless @log_requests
          req = HTTParty.delete(url, headers: @headers, body: body.to_json)
        else
          req = HTTParty.delete(url, headers: @headers, body: body.to_json, debug_output: $stdout)
        end
      end

      valid_response(req)
    end

    def valid_response(req)
      begin
        puts req.to_s
        # ApiController.saveCdtErroLog('Conductor', req.parsed_response, req.code, req.request.last_uri.to_s)
      rescue
      end

      begin
        response = !req.parsed_response.blank? ? req.parsed_response : {}
        if response.kind_of?(Hash)
          response[:statusCode] = req.code
        end
        if response.kind_of?(String)
          responseJson = {}
          responseJson[:message] = response
          responseJson[:statusCode] = req.code
          response = responseJson
        end
        Helper.generate_general_response(response)
      rescue
        Helper.generate_general_response({ message: 'Erro interno Baas', statusCode: 500 })
      end
    end

  end

  module Helper

    def self.generate_general_response(req)
      if req
        {
          success: req[:statusCode] >= 400 ? false : true,
          content: req
        }
      else
        req
      end
    end
    
    def self.json_to_url_params(json)
			string = '?'
			arr = []
			json.keys.each do |key|
				if !json[key].nil?
					arr << key.to_s + '=' + json[key].to_s
				end
			end
			string + arr.join('&')
		end

  end

  class Model < OpenStruct

    def as_json(options = nil)
      @table.as_json(options)
    end

  end
end