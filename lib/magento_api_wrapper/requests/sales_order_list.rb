module MagentoApiWrapper::Requests
  class SalesOrderList

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      sales_order_list_hash
    end

    def sales_order_list_hash
      {
        session_id: self.session_id,
        filters: {
          "complex_filter" => filters_array
        }
      }
    end

    def filters_array
      filters = {}
      filters.compare_by_identity
      filters["complexObjectArray"] = {
        key: "created_at",
        value: created_at_hash
      }
      filters["complexObjectArray"] = {
        key: "state",
        value: status_hash
      }
      filters
    end

      #{complex_object_array: ,
            #complex_object_array: {
              #key: "created_at",
              #value: created_at_hash
            #}
      #}

    def status_hash
      status = {}
      status.compare_by_identity
      status["key"] = "in"
      status_array.each do |o_status|
        status["value"] = o_status
      end
      status
    end

    def status_array
      data[:status_array]
    end

    def created_at_hash
      created_from = {}
      created_from["key"] = "from"
      created_from["value"] = date_filter
      created_from
    end

    def date_filter
      date_filter = data[:last_modified] ? Time.parse(data[:last_modified]).beginning_of_day.to_formatted_s(:db) : (Time.now - 2.weeks).beginning_of_day.to_formatted_s(:db)
      return date_filter
    end

    def session_id
      data[:session_id]
    end

    def filters
      data[:filters]
    end

  end
end
