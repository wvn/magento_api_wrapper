module MagentoApiWrapper::Requests
  class ShipmentList

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      shipment_list_hash
    end

    def shipment_list_hash
      {
        session_id: self.session_id
      }
    end

    def session_id
      data[:session_id]
    end

  end
end
