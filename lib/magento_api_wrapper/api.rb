module MagentoApiWrapper
  class Api

    attr_accessor :magento_url, :magento_username, :magento_api_key

    #Examples below assume api is an initialized MagentoWrapperApi::Api.new
    #api = MagentoApiWrapper::Api.new(magento_url: "yourmagentostore.com/index.php", magento_username: "soap_api_username", magento_api_key: "userkey123")
    def initialize(options = {})
      @magento_url = options.delete(:magento_url)
      @magento_username = options.delete(:magento_username)
      @magento_api_key = options.delete(:magento_api_key)
    end

    #Because these params are used in every call, rather than requiring them each time, merge the common params into your specific call. Do not call this method, it is used throughout the Api class
    def common_params
      {
        magento_url: magento_url,
        magento_username: magento_username,
        magento_api_key: magento_api_key
      }
    end

    #From Magento:
    #login(apiUser, apiKey) Start the API session, return the session ID, and authorize the API user (returns a string)

    #does not take arguements if api variable has been initialized with:
    #magento_url, magento_username, magento_api_key

    #api.login returns the session_id
    def login(params = {})
      begin
        params.merge!(common_params)
        document = MagentoApiWrapper::Requests::Login.new(params)
        request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :login)
        request.body = document.body
        login = MagentoApiWrapper::Login.new(request.connect!)
        @session_id = login.key
        login.key
      rescue MagentoApiWrapper::AuthenticationError => e
        raise e
      end
    end


    #From Magento:
    #startSession()  Start the API session and return session ID (returns a string)
    #api.begin_session simply returns true or false, I use it to authenticate a new store integration.
    #For example: add_store if api.begin_session
    def begin_session
      begin
        true if login
      rescue
        false
      end
    end

    #Reuse the session_id from api.login Prevents calling the API an excessive number of times, logging in for each request
    def session_params(params = {})
      session_id = login
      params.merge!(common_params)
      params.merge!(session_id: session_id)
      params
    end

    def store_list(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::StoreList.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :store_list)
      request.body = document.body
      store_list = MagentoApiWrapper::StoreList.new(request.connect!)
      store_list.store_ids
    end

    def store_info(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::StoreInfo.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :store_info)
      request.body = document.body
      store = MagentoApiWrapper::StoreInfo.new(request.connect!)
      store.name
    end

    #order = api.order_info(increment_id: "100000002")
    #order.result (returns entire order)
    #order.items (returns order line_items)
    #order.shipping_address (returns order shipping address only)
    #order.billing_address (returns order billing address only)
    #order.payment_info (returns order payment information only)
    def order_info(params = {})
      params.merge!(common_params)
      params.merge!(session_params) unless params[:session_id].present?
      document = MagentoApiWrapper::Requests::SalesOrderInfo.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_info)
      request.body = document.body
      MagentoApiWrapper::SalesOrderInfo.new(request.connect!)
    end

    #items_array is the order line items ext_product_id and quantity
    #api.create_invoice(order_id: "100000002", items_array: [{"order_item_id" => "27", "qty" => "4"}, {"order_item_id" => "45", "qty" => "1"}], comment: "Automatically Invoiced by ShippingEasy")
    def create_invoice(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::CreateInvoice.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_invoice_create)
      request.body = document.body
      request.attributes = document.attributes
      invoice = MagentoApiWrapper::CreateInvoice.new(request.connect!)
      invoice.successful?
      #invoice.successful? ? true : invoice_info(order_id: params[:order_id])
    end

    # api.invoice_info(order_id: "100000001")
    def invoice_info(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::InvoiceInfo.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_invoice_info)
      request.body = document.body
      invoice = MagentoApiWrapper::InvoiceInfo.new(request.connect!)
      invoice.invoice_id
      #invoice.exists_for_order?
    end

    # api.create_shipment(order_id: "100000002")
    def create_shipment(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::CreateShipment.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_shipment_create)
      request.body = document.body
      new_shipment = MagentoApiWrapper::CreateShipment.new(request.connect!)
      new_shipment.shipment_id
      #new_shipment.successful? ? true : shipment_info(order_id: params[:order_id])
    end

    def shipment_list(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::ShipmentList.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_shipment_list)
      request.body = document.body
      response = MagentoApiWrapper::ShipmentList.new(request.connect!)
      response.shipment_ids_array
    end

    # api.shipment_info(order_id: "100000001")
    def shipment_info(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::ShipmentInfo.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_shipment_info)
      request.body = document.body
      shipment = MagentoApiWrapper::ShipmentInfo.new(request.connect!)
      #shipment.shipment_id
      shipment.exists_for_order?
    end


    #Magento carrier code options: 'ups', 'usps', 'dhl', 'fedex', or 'dhlint'
    # api.add_tracking_number_to_shipment(increment_id: order_id, shipment_id: "100000001", tracking_number: "ABC123", carrier: "usps", title: "SE Shipment")
    def add_tracking_to_shipment(params = {})
      begin
        shipment_id = params[:shipment_id] || create_shipment(params)
        if shipment_id
          params.merge!(session_params)
          params.merge!(shipment_id: shipment_id)
          document = MagentoApiWrapper::Requests::AddTrackingToShipment.new(params)
          request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_shipment_add_track)
          request.body = document.body
          MagentoApiWrapper::AddTrackingToShipment.new(request.connect!)
          true
        end
      rescue => e
        raise e
      end
    end

  end
end
