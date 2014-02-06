module MagentoApiWrapper

  #parses and returns the session_id returned from the call to login as a string
  class Login < MagentoApiWrapper::Response
    def initialize(response)
      super
    end

    def key
      @document[:login_response][:login_return].to_s
    end
  end

  #class StoreList < MagentoApiWrapper::Response
    #def initialize(response)
      #super
    #end

    #def result
      #@document[:store_list_response]
    #end

    #def is_active?

    #end

    #def store_id_array
      #@document[:store_list_response]
    #end
  #end

  #class StoreInfo < MagentoApiWrapper::Response
    #def initialize(response)
      #super
    #end

    #def result
      #@document[:store_info_response]
    #end

    #def name

    #end
  #end

  #Returns an array of hashes, all the orders in the status passed in api.order_list
  class SalesOrderList < MagentoApiWrapper::Response
    def initialize(response)
      super
    end

    def result
      @document[:sales_order_list_response][:result]
    end

    def collection
      result[:item]
    end
  end


  class SalesOrderInfo < MagentoApiWrapper::Response
    def initialize(response)
      super
    end

    def result
      @document[:sales_order_info_response][:result]
    end

    def items
      result[:items][:item]
    end

    def shipping_address
      result[:shipping_address]
    end

    def billing_address
      result[:billing_adress]
    end

    def payment_info
      result[:payment]
    end

    def status_history
      result[:status_history]
    end
  end

  class CreateInvoice < MagentoApiWrapper::Response
    def initialize(response)
      super
    end

    def result
      @document[:sales_order_invoice_create_response][:result]
    end

    def successful?
      true if result
    end
  end

  class InvoiceInfo < MagentoApiWrapper::Response
    def initialize(response)
      super
      result
    end

    def result
      @document[:sales_order_invoice_info_response][:result]
    end

    def invoice_id
      #TODO: Check this out
    end

    def exists_for_order?
      true if invoice_id
    end
  end

  class CreateShipment < MagentoApiWrapper::Response
    def initialize(response)
      super
    end

    def result
      @document[:sales_order_shipment_create_response]
    end

    def shipment_id
      result[:shipment_increment_id]
    end
  end

  class ShipmentList < MagentoApiWrapper::Response
    def initialize(response)
      super
    end

    def result
      @document[:sales_order_shipment_list_response][:result]
    end

    def shipment_id(item)
      if item[1].is_a? Hash
        id = item[1][:increment_id] if item[1][:increment_id]
      end
      id
    end

    def shipment_ids_array
      shipment_ids = []
      result.each do |item|
        shipment_ids << shipment_id(item) unless shipment_id(item).nil?
      end
      shipment_ids
    end
  end

  class ShipmentInfo < MagentoApiWrapper::Response
    def initialize(response)
      super
      result
    end

    def result
      @document[:sales_order_shipment_info_response][:result]
    end

    def shipment_id
      #TODO: Check this out
    end

    def exists_for_order?
      true if shipment_id
    end
  end

  class AddTrackingToShipment < MagentoApiWrapper::Response
    def initialize(response)
      super
    end

    def result
      @document[:sales_order_shipment_add_track_response][:result]
    end

    def success?
      #true or false
    end
  end
end
