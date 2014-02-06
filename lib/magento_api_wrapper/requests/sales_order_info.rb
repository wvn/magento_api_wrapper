module MagentoApiWrapper::Requests
  class SalesOrderInfo

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      sales_order_info_hash
    end

    def sales_order_info_hash
      {
        session_id: self.session_id,
        order_increment_id: self.order_id
      }
    end

    def session_id
      data[:session_id]
    end

    def order_id
      data[:increment_id]
    end


  end
end
