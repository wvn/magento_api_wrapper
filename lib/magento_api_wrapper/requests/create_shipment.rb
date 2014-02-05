module MagentoApiWrapper::Requests
  class CreateShipment

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      shipment_request_hash
    end

    def shipment_request_hash
      {
        session_id: self.session_id,
        order_increment_id: self.order_id
      }
    end

    def session_id
      data[:session_id]
    end

    def order_id
      data[:order_id]
    end

  end
end
