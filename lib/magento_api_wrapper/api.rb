module MagentoApiWrapper
  class Api

    attr_accessor :magento_url, :magento_username, :magento_api_key

    def initialize(options = {})
      @magento_url = options.delete(:magento_url)
      @magento_username = options.delete(:magento_username)
      @magento_api_key = options.delete(:magento_api_key)
    end

    def common_params
      {
        magento_url: magento_url,
        magento_username: magento_username,
        magento_api_key: magento_api_key
      }
    end

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

    def begin_session
      begin
        true if login
      rescue
        false
      end
    end

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

    def order_list(params = {}) #api.order_list(status_array: ['new'], last_modified: (Time.now - 2.weeks).beginning_of_day.to_formatted_s(:db) )
      #last_modified if nil will be: (Time.now - 2.weeks).beginning_of_day.to_formatted_s(:db)
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::SalesOrderList.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_list)
      request.body = document.body
      orders = MagentoApiWrapper::SalesOrderList.new(request.connect!)
      orders.collection
    end

    #api.order_info.result
    #api.order_info.items (line_items)
    #api.order_info.shipping_address
    #api.order_info.billing_address
    #api.order_info.payment_info
    def order_info(params = {}) # api.order_info(order_id: "100000002")
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

    # carrier code options: ups, usps, dhl, fedex, or dhlint
    # api.add_tracking_number_to_shipment(order_id: order_id, shipment_id: "100000001", tracking_number: "ABC123", carrier: "usps", title: "SE Shipment")
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
