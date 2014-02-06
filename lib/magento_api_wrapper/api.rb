module MagentoApiWrapper
  class Api

    attr_accessor :magento_url, :magento_username, :magento_api_key

    #Examples below assume api is an initialized MagentoWrapperApi::Api.new
    #api = MagentoApiWrapper::Api.new(magento_url: "yourmagentostore.com/index.php", magento_username: "soap_api_username", magento_api_key: "userkey123")
    def initialize(options = {})
      @magento_url = options.delete(:magento_url)
      @magento_username = options.delete(:magento_username)
      @magento_api_key = options.delete(:magento_api_key)
    end

    #Because these params are used in every call, rather than requiring them each time, merge the common params into your specific call. Do not call this method, it is used throughout the Api class
    def common_params
      {
        magento_url: magento_url,
        magento_username: magento_username,
        magento_api_key: magento_api_key
      }
    end

    #From Magento:
    #login(apiUser, apiKey) Start the API session, return the session ID, and authorize the API user (returns a string)

    #does not take arguements if api variable has been initialized with:
    #magento_url, magento_username, magento_api_key

    #api.login returns the session_id
    def login(params = {})
      begin
        params.merge!(common_params)
        document = MagentoApiWrapper::Requests::Login.new(params)
        request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :login)
        request.body = document.body
        login = MagentoApiWrapper::Login.new(request.connect!)
        @session_id = login.key
        login.key
      rescue MagentoApiWrapper::AuthenticationError => e
        raise e
      end
    end


    #From Magento:
    #startSession()  Start the API session and return session ID (returns a string)
    #api.begin_session simply returns true or false, I use it to authenticate a new store integration.
    #For example: add_store if api.begin_session
    def begin_session
      begin
        true if login
      rescue
        false
      end
    end

    #Reuse the session_id from api.login Prevents calling the API an excessive number of times, logging in for each request
    def session_params(params = {})
      session_id = login
      params.merge!(common_params)
      params.merge!(session_id: session_id)
      params
    end

    def store_list(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::StoreList.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :store_list)
      request.body = document.body
      store_list = MagentoApiWrapper::StoreList.new(request.connect!)
      store_list.store_ids
    end

    def store_info(params = {})
      params.merge!(session_params)
      document = MagentoApiWrapper::Requests::StoreInfo.new(params)
      request = MagentoApiWrapper::Request.new(magento_url: params[:magento_url], call_name: :store_info)
      request.body = document.body
      store = MagentoApiWrapper::StoreInfo.new(request.connect!)
      store.name
    end

    #TODO: directoryCountryList
    #TODO: directoryRegionList
    #TODO: magentoInfo

  end
end
