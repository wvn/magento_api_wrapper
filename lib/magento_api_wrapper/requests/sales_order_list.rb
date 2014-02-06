module MagentoApiWrapper::Requests
  class SalesOrderList

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      merge_filters!(sales_order_list_hash)
    end

    def sales_order_list_hash
      {
        session_id: self.session_id
      }
    end

    def merge_filters!(sales_order_list_hash)
      sales_order_list_filters = {}
      if !filters_array.empty?
        sales_order_list_filters["complex_filter"] = filters_array
        sales_order_list_hash.merge!(sales_order_list_filters)
      else
        sales_order_list_hash
      end
    end

    def filters_array
      custom_filters = {}
      custom_filters.compare_by_identity
      if last_modified
        custom_filters["complexObjectArray"] = {
          key: "created_at",
          value: created_at_hash
        }
      end
      if status_array
        custom_filters["complexObjectArray"] = {
          key: "state",
          value: status_hash
        }
      end
      if filters
        filters.each do |key, value_hash|
          custom_filters["complexObjectArray"] = {
            key: key,
            value: value_hash
          }
        end
      end
      custom_filters
    end

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

    def created_at_key
      data[:created_at_key]
    end

    def last_modified
      data[:last_modified]
    end

    def date_filter
      begin
        Time.parse(last_modified).beginning_of_day.to_formatted_s(:db)
      rescue MagentoApiWrapper::BadRequest => e
        raise e
      end
    end

    def session_id
      data[:session_id]
    end

    def filters
      data[:filters]
    end

  end
end
