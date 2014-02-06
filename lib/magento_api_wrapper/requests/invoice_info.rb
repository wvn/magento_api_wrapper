module MagentoApiWrapper::Requests
  class InvoiceInfo

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      #TODO: Check this out
      merge_filters(invoice_info_hash) unless self.order_id.nil?
    end

    def invoice_info_hash
      {
        session_id: self.session_id
      }
    end

    def session_id
      data[:session_id]
    end

    def order_id
      data[:order_id]
    end

    def merge_filters(invoice_info_hash)
      filters = {
        filters: {
          "complex_filter" => {
            complex_object_array: {
              key: "order_increment_id",
              value: order_id_hash
            },
          }
        }
      }
      return invoice_info_hash.merge!(filters)
    end

    def order_id_hash
      order = {}
      order["key"] = "eq"
      order["value"] = order_id
      order
    end

  end
end
