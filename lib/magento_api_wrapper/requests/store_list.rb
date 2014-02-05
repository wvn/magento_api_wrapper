module MagentoApiWrapper::Requests
  class StoreList

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      store_list_hash
    end

    def store_list_hash
      {
        session_id: session_id
      }
    end

    def session_id
      data[:session_id]
    end
  end
end
