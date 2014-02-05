require 'magento_api_wrapper/connection'
require 'magento_api_wrapper/savon_client'

require 'magento_api_wrapper/api'
require 'magento_api_wrapper/api_error'

require 'magento_api_wrapper/request'
require 'magento_api_wrapper/requests/add_tracking_to_shipment'
require 'magento_api_wrapper/requests/create_shipment'
require 'magento_api_wrapper/requests/create_invoice'
require 'magento_api_wrapper/requests/invoice_info'
require 'magento_api_wrapper/requests/login'
require 'magento_api_wrapper/requests/sales_order_info'
require 'magento_api_wrapper/requests/sales_order_list'
require 'magento_api_wrapper/requests/shipment_list'
require 'magento_api_wrapper/requests/shipment_info'

require 'magento_api_wrapper/response'
require 'magento_api_wrapper/response_collection'
require 'magento_api_wrapper/responses'
require 'magento_api_wrapper/version'

module MagentoApiWrapper
  class Error < StandardError; end
  class UnknownError < StandardError; end
  class MagentoError < Error; end
  class AuthenticationError < Error; end
  class UnknownRequest < Error; end
  class UnavailableError < Error; end
  class BadRequest < Error; end
end
