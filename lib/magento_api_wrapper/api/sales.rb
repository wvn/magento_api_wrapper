module MagentoApiWrapper
  class Sales < MagentoApiWrapper::Api
    #Mage_Sales

    #TODO
    #sales_order.addComment - Add a comment to an order
    #sales_order.hold - Hold an order
    #sales_order.unhold - Unhold an order
    #sales_order.cancel - Cancel an order
    #sales_order_invoice.addComment - Add a new comment to an invoice
    #sales_order_invoice.capture - Capture an invoice
    #sales_order_invoice.cancel - Cancel an invoice
    #sales_order_shipment.addComment - Add a new comment to a shipment
    #sales_order_shipment.removeTrack - Remove tracking number from a shipment
    #sales_order_shipment.getCarriers - Retrieve a list of allowed carriers for an order
    #sales_order_creditmemo.list - Retrieve the list of credit memos by filters
    #sales_order_creditmemo.info - Retrieve the credit memo information
    #sales_order_creditmemo.create - Create a new credit memo for order
    #sales_order_creditmemo.addComment - Add a new comment to the credit memo
    #sales_order_creditmemo.cancel - Cancel the credit memo

    #Examples below assume api is an initialized MagentoWrapperApi::Api.new
    #api = MagentoApiWrapper::Api.new(magento_url: "yourmagentostore.com/index.php", magento_username: "soap_api_username", magento_api_key: "userkey123")
    def initialize(options = {})
      super
    end

    #Valid, standard order statuses for Magento SOAP API v2:
    #-'pending'
    #-'pending_payment'
    #-'processing'
    #-'holded'
    #-'complete'
    #-'closed'
    #-'canceled'
    #-'fraud'
    #Magento also allows custom statuses, so to get all orders DO NOT pass a status. You will have to iterate through returned orders to discover list of custom statuses for individual installations of Magento.

    #You CANNOT pass multiple filters for the same key. The example below will NOT work unfortunately. For example, if you are attempting to get orders created between November 21, 2013 and January 31, 2014, you cannot pass the code below, only the first filter will be acknowledged by Magento:
    #api.order_list(complex_filters: [{key: 'created_at', operator: "from", value: "11/21/2013" }, {key: "created_at", operator: "to", value: "1/31/2014"}])

    #[Magento filters: from http://bit.ly/N6dRD4]
    #The following is a list of valid complex_filter filter keys for Magento SOAP API v2. They are part of a complexObjectArray
    #-"from" returns rows that are after this value (datetime only)
    #-"to" returns rows that are before this value (datetime only)
    #-"eq" returns rows equal to this value
    #-"neq" returns rows not equal to this value
    #-"like" returns rows that match this value (with % as a wildcard)
    #-"nlike" returns rows that do not match this value (with % as a wildcard)
    #-"in" rows where the value is in this array (pass an array in)
    #-"nin" returns rows where the value is not in this array (pass an array in)
    #-"is" use interchangeably with eq
    #-"null" returns rows that are null
    #-"notnull" returns rows that are not null
    #-"gt" returns rows greater than this value
    #-"lt" returns rows less than this value
    #-"gteq" returns rows greater than or equal to this value
    #-"lteq" returns rows less than or equal to this value
    #-"moreq" unsure
    #-"finset" unsure

    #api.order_list(simple_filters: [{key: "status" value: "processing"}])
    #api.order_list(simple_filters: [{key: "status", value: "processing"}, {key: created_at, value: "12/10/2013" }])
    #api.order_list(complex_filters: [{key: "status", value: ["processing", "completed"]}, {key: created_at, value: "12/10/2013" }])
    def order_list(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::SalesOrderList.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_list)
      request.body = document.body
      request.attributes = document.attributes
      orders = MagentoApiWrapper::SalesOrderList.new(request.connect!)
      orders.collection
    end

    #order = api.order_info(increment_id: "100000002")
    #order.result (returns entire order)
    #order.items (returns order line_items)
    #order.shipping_address (returns order shipping address only)
    #order.billing_address (returns order billing address only)
    #order.payment_info (returns order payment information only)
    def order_info(params = {})
      params.merge!(common_params)
      params.merge!(session_params) unless ! params[:session_id].nil? and params[:session_id].present?
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

    # api.invoice_list
    def invoice_list(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::InvoiceList.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_invoice_list)
      request.body = document.body
      MagentoApiWrapper::InvoiceList.new(request.connect!)
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

    def add_comment_to_order(params = {})
      begin
        order_increment_id = params[:order_increment_id]
        comment = params[:comment]
        status = params[:status]

        if order_increment_id
          params.merge!(session_params)
          params.merge!(order_increment_id: order_increment_id)
          params.merge!(comment: comment)
          params.merge!(status: status)
          document = MagentoApiWrapper::Requests::AddCommentToOrder.new(params)
          request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_add_comment)
          request.body = document.body
          MagentoApiWrapper::AddCommentToOrder.new(request.connect!)
          true
        end

      rescue => e
        raise e
      end
    end

  end
end
