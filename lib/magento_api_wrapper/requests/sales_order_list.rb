module MagentoApiWrapper::Requests
  class SalesOrderList

    attr_accessor :data

    def initialize(data = {})
      @data = data
    end

    def body
      merge_filters!(sales_order_list_hash)
    end

    def attributes
      { session_id: { "xsi:type" => "xsd:string" },
        filters: { "xsi:type" => "ns1:filters" },
      }
    end

    def sales_order_list_hash
      {
        session_id: self.session_id
      }
    end

    def merge_filters!(sales_order_list_hash)
      if !filters_array.empty?
        sales_order_list_filters = {
          filters: filters_array,
          :attributes! => {
            filter: {
              "SOAP-ENC:arrayType" => "ns1:associativeEntity[2]",
              "xsi:type" => "ns1:associativeArray" },
          }
        }
        sales_order_list_hash.merge!(sales_order_list_filters)
      else
        sales_order_list_hash
      end
    end

    def filters_array
      custom_filters = {}
      custom_filters.compare_by_identity
      if last_modified
        custom_filters["filter"] = {
          item: {
          key: "updated_at",
          value: last_modified_hash
          }
        }
      end
      if created_at_from
        custom_filters["filter"] = {
          item: {
            key: "created_at",
            value: created_at_hash,
            :attributes! => {
              key: { "xsi:type" => "xsd:string" },
              value: { "xsi:type" => "xsd:string" }
            }
          },
          :attributes! => {
            item: { "xsi:type" => "ns1:associativeEntity" },
          },
        }
      end
      if status_array
        custom_filters["filter"] = {
          item: {
            key: "status",
            value: status_array.first,
            :attributes! => {
              key: { "xsi:type" => "xsd:string" },
              value: { "xsi:type" => "xsd:string" }
            }
          },
          :attributes! => {
            item: { "xsi:type" => "ns1:associativeEntity" },
          },
        }
      end
      if filters
        filters.each do |key, value_hash|
          custom_filters["filter"] = {
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
      status["key"] = "eq"
      #status["key"] = "status"
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
      created_from.compare_by_identity
      created_from["key"] = "from"
      created_from["value"] = created_at_from_filter
      created_from["key"] = "to"
      created_from["value"] = created_at_to_filter
      created_from
    end

    def created_at_from
      data[:created_at_from]
    end

    def created_at_to
      data[:created_at_to]
    end

    def last_modified_hash
      last_modified = {}
      last_modified["key"] = "from"
      last_modified["value"] = last_modified_filter
      last_modified
    end

    def last_modified
      data[:last_modified]
    end

    def created_at_from_filter
      begin
        Time.parse(created_at_from).strftime("%Y-%m-%d %H:%M:%S")
      rescue MagentoApiWrapper::BadRequest => e
        raise e
      end
    end

    def created_at_to_filter
      if created_at_to
        Time.parse(created_at_to).strftime("%Y-%m-%d %H:%M:%S")
      else
        Time.now.strftime("%Y-%m-%d %H:%M:%S")
      end
    end

    def last_modified_filter
      begin
        Time.parse(last_modified).strftime("%Y-%m-%d %H:%M:%S")
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
