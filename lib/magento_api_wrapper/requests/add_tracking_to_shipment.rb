module MagentoApiWrapper::Requests
  class AddTrackingToShipment

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
        shipment_increment_id: self.shipment_id,
        track_number: self.tracking_number,
        carrier: self.carrier,
        title: self.title
      }
    end

    def session_id
      data[:session_id]
    end

    def shipment_id
      data[:shipment_id]
    end

    def tracking_number
      data[:tracking_number]
    end

    def carrier
      data[:carrier]
    end

    def title
      data[:title]
    end

  end
end
