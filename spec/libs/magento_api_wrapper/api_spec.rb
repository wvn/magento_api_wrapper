require 'spec_helper'

describe MagentoApiWrapper do

  let(:url) { attributes_for(:magento)[:url] }
  let(:username) { attributes_for(:magento)[:username] }
  let(:password) { attributes_for(:magento)[:password] }
  let(:api) { MagentoApiWrapper::Api.new(magento_api_key: password, magento_url: url, magento_username: username) }
  let(:bad_api) { MagentoApiWrapper::Api.new(magento_api_key: "bad_password", magento_url: url, magento_username: "bad_username") }

  describe "#login" do
    context "log in with valid credentials returns session id" do
      let(:login) do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/login/valid_credentials' ) do
          api.login
        end
      end
      specify { login.should == "4e5d83f3e796b7bd82e594a04130060e" }
    end

    context "invalid credentials return false" do
      it "raises an auth error" do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/login/invalid_credentials' ) do
          expect { bad_api.login }.to raise_error(MagentoApiWrapper::AuthenticationError)
        end
      end
    end
  end #describe

  describe "#begin_session" do
    context "log in with valid credentials returns true" do
      let(:begin_session) do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/begin_session/valid_credentials' ) do
          api.begin_session
        end
      end
      specify { begin_session.should be_true}
    end #context

    context "log in with invalid credentials returns false" do
      let(:begin_session) do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/begin_session/invalid_credentials' ) do
          bad_api.begin_session
        end
      end
      specify { begin_session.should be_false }
    end #context
  end #describe

  describe "#session_params" do
    context "common_params should eq api initialized attrs" do
      let(:common_params) do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/common_params/valid_credentials' ) do
          api.common_params
        end
      end
      let(:api_attrs) { {magento_api_key: password, magento_url: url, magento_username: username, } }
      specify { common_params.should == api_attrs }
    end #context

    context "session_params should eq common_params plus session_id" do
      let(:session_params) do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/session_params/valid_credentials' ) do
          api.session_params
        end
      end
      let(:common_params) { {magento_api_key: password,
            magento_url: url,
            magento_username: username,
            session_id: "07d6dbff670180e2904f811155f21fa0"} }
      specify { session_params.should == common_params}
    end #context
  end #describe

  describe "#order_list" do
    context "returns a collection of orders" do
      let(:order_list) do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/order_list/orders_collection' ) do
          api.order_list(status_array: ['new'])
        end
      end
      specify { order_list.class.should == Array }
      specify { order_list.first.class.should == Hash }
      specify { order_list.first[:increment_id].should == "100000001" }
      specify { order_list.first[:status].should == "pending" }
      specify { order_list.first[:state].should == "new" }
    end #context
  end #describe

  describe "#order_info" do
    context "returns order details" do
      let(:order_info) do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/order_info/order_info' ) do
          api.order_info(order_id: "100000001")
        end
      end
      specify { order_info.result.class.should == Hash }
      specify { order_info.items[:price].should == "2699.9900" }
      specify { order_info.shipping_address[:region].should == "Texas" }
      specify { order_info.shipping_address[:country_id].should == "US" }
      specify { order_info.shipping_address[:street].should == "609 Castle Ridge Rd\nSuite 445" }
      specify { order_info.payment_info[:amount_ordered].should == "2704.9900"}
      specify { order_info.payment_info.keys.should == [:parent_id, :amount_ordered, :shipping_amount, :base_amount_ordered, :base_shipping_amount, :method, :cc_exp_month, :cc_exp_year, :cc_ss_start_month, :cc_ss_start_year, :payment_id, :"@xsi:type"] } 
      specify { order_info.items.keys.should == [:item_id, :order_id, :quote_item_id, :created_at, :updated_at, :product_id, :product_type, :product_options, :weight, :is_virtual, :sku, :name, :free_shipping, :is_qty_decimal, :no_discount, :qty_canceled, :qty_invoiced, :qty_ordered, :qty_refunded, :qty_shipped, :price, :base_price, :original_price, :base_original_price, :tax_percent, :tax_amount, :base_tax_amount, :tax_invoiced, :base_tax_invoiced, :discount_percent, :discount_amount, :base_discount_amount, :discount_invoiced, :base_discount_invoiced, :amount_refunded, :base_amount_refunded, :row_total, :base_row_total, :row_invoiced, :base_row_invoiced, :row_weight, :weee_tax_applied, :weee_tax_applied_amount, :weee_tax_applied_row_amount, :base_weee_tax_applied_amount, :base_weee_tax_applied_row_amount, :weee_tax_disposition, :weee_tax_row_disposition, :base_weee_tax_disposition, :base_weee_tax_row_disposition, :"@xsi:type"]}
      specify { order_info.shipping_address.keys.should == [:parent_id, :address_type, :firstname, :lastname, :street, :city, :region, :postcode, :country_id, :telephone, :region_id, :address_id, :"@xsi:type"] }
    end #context
  end #describe

  describe "#create_invoice" do
    context "new invoice returns true" do
      let(:create_invoice) do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/create_invoice/create_invoice' ) do
          api.create_invoice(order_id: "100000001", items_array: [{"order_item_id" => "27", "qty" => "4"}, {"order_item_id" => "45", "qty" => "1"}], comment: "Automatically Invoiced by ShippingEasy")
        end
      end
      specify { create_invoice.should be_true }
    end

    context "duplicate invoice returns Magento error" do
      it "raises a Magento error" do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/create_invoice/duplicate_invoice' ) do
          expect { api.create_invoice(order_id: "100000002", items_array: [{"order_item_id" => "27", "qty" => "4"}, {"order_item_id" => "45", "qty" => "1"}], comment: "Automatically Invoiced by ShippingEasy") }.to raise_error(MagentoApiWrapper::Error)
        end
      end
    end
  end #describe

  describe "#create_shipment" do
    context "new shipment returns true" do
      let(:create_shipment) do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/create_shipment/create_shipment' ) do
          api.create_shipment(order_id: "100000001")
        end
      end
      specify { create_shipment.should == "100000015" }
    end

    context "duplicate shipment returns Magento error" do
      it "raises a Magento error" do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/create_shipment/duplicate_shipment' ) do
          expect { api.create_shipment(order_id: "100000001")}.to raise_error(MagentoApiWrapper::Error)
        end
      end
    end
  end #describe

  describe "#add_tracking_to_shipment" do
    context "successfully adding tracking number to shipment returns true" do
      let(:add_tracking) do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/add_tracking_to_shipment/add_tracking' ) do
          api.add_tracking_to_shipment(order_id: "100000001", shipment_id: "100000015" , tracking_number: "ABC123", carrier: "usps", title: "Failed Tracking")
        end
      end
      specify { add_tracking.should be_true }
    end

    context "failure to add tracking" do
      it "raises a Magento error" do
        VCR.use_cassette('magento/magento_api_wrapper/api_spec/add_tracking_to_shipment/failure_to_add_tracking' ) do
          expect { api.add_tracking_to_shipment(order_id: "100000001", tracking_number: "ABC123", carrier: "usps", title: "Failed Tracking") }.to raise_error(MagentoApiWrapper::Error)
        end
      end
    end
  end #describe

end
