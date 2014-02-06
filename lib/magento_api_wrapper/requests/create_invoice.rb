module MagentoApiWrapper::Requests
  class CreateInvoice

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      invoice_request_hash
    end

    def attributes
      {
        items_qty: {
          "xsi:type" => "urn:orderItemIdQtyArray",
          "soapenc:arrayType" => "urn:orderItemIdQty[]"
        }
      }
    end

    def invoice_request_hash
      {
        session_id: self.session_id,
        invoice_increment_id: self.order_id,
        items_qty: "",
        comment: self.comment,
      }
    end

    def session_id
      data[:session_id]
    end

    def order_id
      data[:order_id].to_s
    end

    #[{"order_item_id" => "27", "qty" => "4"}, {"order_item_id" => "45", "qty" => "1"}]
    def items_array
      data[:items_array]

    end

    def comment
      data[:comment]
    end
  end
end
