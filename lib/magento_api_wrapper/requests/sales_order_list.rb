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
        }
        sales_order_list_hash.merge!(sales_order_list_filters)
      else
        sales_order_list_hash
      end
    end

    def filters_array
      custom_filters = {}
      custom_filters.compare_by_identity
      if !simple_filters.nil?
        add_simple_filters(custom_filters)
      end

      if !complex_filters.nil?
        add_complex_filters(custom_filters)
      end
      custom_filters
    end

    def add_simple_filters(custom_filters)
      simple_filters.each do |sfilter|
        custom_filters[:attributes!] = {
          "filter" => {
            "SOAP-ENC:arrayType" => "ns1:associativeEntity[2]",
            "xsi:type" => "ns1:associativeArray"
          }
        }
        custom_filters["filter"] = {
          item: {
            key: sfilter[:key],
            value: sfilter[:value],  #formatted_timestamp(created_at)
            :attributes! => {
              key: { "xsi:type" => "xsd:string" },
              value: { "xsi:type" => "xsd:string" }
            },
          },
          :attributes! => {
            item: { "xsi:type" => "ns1:associativeEntity" },
          },
        }
      end
      custom_filters
    end

    def add_complex_filters(custom_filters)
      complex_filters.each do |cfilter|
        custom_filters[:attributes!] = {
          "complex_filter" => {
            "SOAP-ENC:arrayType" => "ns1:complexFilter[2]",
            "xsi:type" => "ns1:complexFilterArray"
          }
        }
        custom_filters["complex_filter"] = {
          item: {
            key: cfilter[:key],
            value: {
              key: cfilter[:operator],
              value: cfilter[:value]
            },
            :attributes! => {
              key: { "xsi:type" => "xsd:string" },
              value: { "xsi:type" => "xsd:associativeEntity" }
            },
          },
          :attributes! => {
            item: { "xsi:type" => "ns1:complexFilter" },
          },
        }
      end
      custom_filters
    end

    def formatted_timestamp(timestamp)
      begin
        Time.parse(timestamp).strftime("%Y-%m-%d %H:%M:%S")
      rescue MagentoApiWrapper::BadRequest => e
        raise "Did you pass date in format YYYY-MM-DD? Error: #{e}"
      end
    end

    def status_array
      data[:status_array]
    end

    def created_at_from
      data[:created_at_from]
    end

    def created_at_to
      data[:created_at_to]
    end

    def last_modified
      data[:last_modified]
    end

    def session_id
      data[:session_id]
    end

    def simple_filters
      data[:simple_filters]
    end

    def complex_filters
      data[:complex_filters]
    end
  end
end
