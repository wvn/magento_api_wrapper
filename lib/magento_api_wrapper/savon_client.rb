module MagentoApiWrapper
  class SavonClient

    attr_accessor :request

    def initialize(request)
     @request = request
     @magento_url = request.magento_url
    end

    def call
      client.call(@request.call_name, message: message_with_attributes, response_parser: :nokogiri)
    end

    def message_with_attributes
      @request.body.merge!(:attributes! => @request.attributes) if @request.attributes.present?
      return @request.body
    end

    def client
      Savon::Client.new do |savon|
        savon.ssl_verify_mode          :none
        savon.wsdl                     base_url
        savon.namespaces               namespaces
        savon.env_namespace            :soapenv
        savon.raise_errors             false
        #savon.namespace_identifier     #none
        savon.convert_request_keys_to  :lower_camelcase
        savon.strip_namespaces         true
        savon.pretty_print_xml         true
        savon.log                      log_env
        savon.open_timeout             10    #seconds
        savon.read_timeout             45    #seconds
      end
    end

    def log_env
      true
    end

    def response_tag_format_lambda
      lambda { |key| key.snakecase.downcase }
    end

    def namespaces
      {
        'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/'
      }
    end

    def base_url
      "#{@magento_url}/api/v2_soap?wsdl=1"
    end
  end
end
