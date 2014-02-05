module MagentoApiWrapper::Requests
  class StoreInfo

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      store_info_hash
    end

    def store_info_hash
      {
        session_id: session_id,
        store_id: store_id
      }
    end

    def session_id
      data[:session_id]
    end

    def store_id
      data[:store_id]
    end
  end
end
