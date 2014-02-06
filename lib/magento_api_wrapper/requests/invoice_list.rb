module MagentoApiWrapper::Requests
  class InvoiceList

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      invoice_list_hash
    end

    def invoice_info_hash
      {
        session_id: self.session_id
      }
    end

    def session_id
      data[:session_id]
    end

  end
end
