module MagentoApiWrapper
  class Sales < MagentoApiWrapper::Api

    #Examples below assume api is an initialized MagentoWrapperApi::Api.new
    #api = MagentoApiWrapper::Api.new(magento_url: "yourmagentostore.com/index.php", magento_username: "soap_api_username", magento_api_key: "userkey123")
    def initialize(options = {})
      super
    end

    #Notes on status_array
    #status_array should be an array of all statuses you want returned.
    #Valid order statuses for Magento: "processing", "pending payment", "suspected fraud", "payment review", "pending", "on hold", "complete", "closed", "canceled", "pending paypal"
    #Magento also allows custom statuses, so to get all orders DO NOT pass status_array. You will have to iterate through returned orders for statuses you want.

    #Notes on last_modified
    #You can pass a valid timestamp in any format and it will be parsed and formatted correctly. If a valid timestamp is not passed, fall back to default.
    #Required format for timestamps in Magento is to_formatted_s(:db)
    #five_weeks_ago = (Time.now - 5.weeks).beginning_of_day.to_formatted_s(:db) )
    #last_modified automatically set to two weeks ago if not set: (Time.now - 2.weeks).beginning_of_day.to_formatted_s(:db)

    #Notes on created_at

    #TODO: Allow custom filters for all keys
    #api.order_list(filters: {key: 'created_at', value: {"key" => "from", "value" =>(Time.now - 3.weeks).beginning_of_day.to_formatted_s(:db)}}
    #[Magento filters: from http://bit.ly/N6dRD4]
    #The following is a list of valid complex_filter filter keys for Magento SOAP API v2. They are part of a complexObjectArray
    #-"from" returns rows that are after this value (datetime only)
    #-"to" returns rows that are before this value (datetime only)
    #-"eq" returns rows equal to this value
    #-"neq" returns rows not equal to this value
    #-"like" returns rows that match this value (with % as a wildcard)
    #-"nlike" returns rows that do not match this value (with % as a wildcard)
    #-"i rows where the value is in this array (pass an array in)
    #-"nin" returns rows where the value is not in this array (pass an array in)
    #-"is" use interchangeably with eq
    #-"null" returns rows that are null
    #-"notnull" returns rows that are not null
    #-"gt" returns rows greater than this value
    #-"lt" returns rows less than this value
    #-"gteq" returns rows greater than or equal to this value
    #-"lteq" returns rows less than or equal to this value
    #-"moreq" unsure
    #-"finset" unsure

    #Returns an array of hashes with orders
    #api.order_list(status_array: ['pending', 'processing'], last_modified: five_weeks_ago)
    def order_list(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::SalesOrderList.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :sales_order_list)
      request.body = document.body
      orders = MagentoApiWrapper::SalesOrderList.new(request.connect!)
      orders.collection
    end

  end
end
