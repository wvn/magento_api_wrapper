module MagentoApiWrapper
  class Connection

    class << self

      attr_writer :adapter

      define_method :call do |request|
        response = self.adapter(request).send(:call)
        self.raw_response(request, response)
      end

      def adapter(request)
        @adapter || MagentoApiWrapper::SavonClient.new(request)
      end

      def raw_response(request, response)
        if error_present?(response.body)
          response_info = {request: request, response: response.body}
          raise_magento_error(response_info)
        else
          response
        end
      end

      def error_present?(response)
        response.keys[0] == :fault
      end

      def raise_magento_error(response)
        api_error = parse_error(response)
        case api_error.code(response)
        when "0"
          raise MagentoApiWrapper::UnknownError, api_error.to_s(response)
        when "1"
          raise MagentoApiWrapper::MagentoError, api_error.to_s(response)
        when "2"
          raise MagentoApiWrapper::AuthenticationError, api_error.to_s(response)
        when "3"
          raise MagentoApiWrapper::UnknownRequest, api_error.to_s(response)
        when "4"
          raise MagentoApiWrapper::UnavailableError, api_error.to_s(response)
        when "SOAP-ENV:Server"
          raise MagentoApiWrapper::BadRequest, api_error.to_s(response)
        when "SOAP-ENV:Client"
          raise MagentoApiWrapper::BadRequest, api_error.to_s(response)
        else
          raise MagentoApiWrapper::Error, api_error.to_s(response)
        end
      end

      def parse_error(response)
        MagentoApiWrapper::ApiError.new(response)
      end
    end
  end
end
