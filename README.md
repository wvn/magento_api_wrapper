# MagentoApiWrapper

Magento API Wrapper allows you to make calls to Magento's SOAP API. You
can download orders from a store, invoice orders, and update orders as
shipped.

You must first configure your Magento installation properly, creating a
user who has access to the SOAP API. Follow the wiki on how to create
this user here.

## To install: 

Add this line to your application's Gemfile:

    gem 'magento_api_wrapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install magento_api_wrapper

## Usage


##Notes on filters


MagentoApiWrapper allows for two types of filters, <b>simple filters</b>
and <b>complex filters</b>. 


###Simple Filters
Simple filters have a key and a value. The key is part of the Magento
object your retrieving, the value is the specific value you want
returned to you. For example, if you want a Magento store's sales orders
with a status of "complete", you will pass:

```ruby
api.order_list(simple_filters: [{key: "status" value: "complete"}])
```


NOTE: If you want multiple statuses, you will use a complex filter with
an array of the statuses you want. 


You can pass multiple simple filters. If you want all orders in
processing status that were created_at noon on December 10, 2013, you
would pass the code below. 


```ruby
api.order_list(simple_filters: [{key: "status", value: "processing"},
{key: created_at, value: "12/10/2013 12:00" }])
```

NOTE: Any datetime field is probably better off using a complex_filter
with an operator, like
```ruby
{key: "created_at", operator: "from", value: "12/10/2013"}
```

###Complex Filters
Complex filters have <b>operators</b> (I've supplied a list of Magento
operators below that I'm not sure is comprehensive, but it's a starting
point.)


```ruby
api.order_list(complex_filters: [{key: "status", operator: "eq", value:
["processing", "completed"]}, {key: created_at, operator: "from", value:
"12/10/2013" }])
```


You CANNOT pass multiple filters for the same key. The example below
will NOT work unfortunately. For example, if you are attempting to get
orders created between November 21, 2013 and January 31, 2014, you
cannot pass the code below, only the first filter will be acknowledged
by Magento:

```ruby
api.order_list(complex_filters: [{key: 'created_at', operator: "from",
value: "11/21/2013" }, {key: "created_at", operator: "to", value:
"1/31/2014"}])
```


###Magento Complex Filter Operators
Magento filters: from http://bit.ly/N6dRD4
The following is a list of valid complex_filter filter keys for Magento
SOAP API v2. They are part of a complexObjectArray. This may not be a
comprehensive list.


-"from" returns rows that are after this value (datetime only)

-"to" returns rows that are before this value (datetime only)

-"eq" returns rows equal to this value

-"neq" returns rows not equal to this value

-"like" returns rows that match this value (with % as a wildcard)

-"nlike" returns rows that do not match this value (with % as a wildcard)

-"in" rows where the value is in this array (pass an array in)

-"nin" returns rows where the value is not in this array (pass an array in)

-"is" use interchangeably with eq

-"null" returns rows that are null

-"notnull" returns rows that are not null

-"gt" returns rows greater than this value

-"lt" returns rows less than this value

-"gteq" returns rows greater than or equal to this value

-"lteq" returns rows less than or equal to this value

-"moreq" unsure

-"finset" unsure


###Magento Standard Statuses
Valid, standard order statuses for Magento SOAP API v2:

-'pending'

-'pending_payment'

-'processing'

-'holded'

-'complete'

-'closed'

-'canceled'

-'fraud'


NOTE: Magento also allows custom statuses, so to get all orders DO NOT
pass status_array. You will have to iterate through returned orders to
discover list of custom statuses for individual installations of
Magento.


###Notes on datetime fields
If you are filtering on a datetime field, you can pass a valid timestamp
in any format and it will be parsed and formatted correctly. The
required format for timestamps in Magento is:

```ruby
Time.parse(timestamp).strftime("%Y-%m-%d %H:%M:%S")
-or-
Time.now.to_formatted_s(:db)
```


###General Notes:
There are more detailed usage notes for each of the Magento modules:

- [MagentoApiWrapper::Api](https://github.com/harrisjb/magento_api_wrapper/wiki/Mage_Directory,-Mage_Core:-Using-MagentoApiWrapper::Api): Covers Mage_Directory, Mage_Core

- [MagentoApiWrapper::Cart](https://github.com/harrisjb/magento_api_wrapper/wiki/Mage_Checkout:-Using-MagentoApiWrapper::Cart): Covers Mage_Checkout

- [MagentoApiWrapper::Catalog](https://github.com/harrisjb/magento_api_wrapper/wiki/Mage_Catalog,-Mage_CatalogInventory:-Using-MagentoApiWrapper::Catalog): Covers Mage_Catalog, Mage_CatalogInventory

- [MagentoApiWrapper::Customer](https://github.com/harrisjb/magento_api_wrapper/wiki/Mage_Customer:-Using-MagentoApiWrapper::Customer): Covers Mage_Customer

- [MagentoApiWrapper::Sales](https://github.com/harrisjb/magento_api_wrapper/wiki/Mage_Sales:-Using-MagentoApiWrapper::Sales): Covers Mage_Sales




###Full list of Magento 
Full list of Magento SOAP v2 API Calls:

Catalog Methods:

-catalog_category.currentStore - Set/Get the current store view

-catalog_category.tree - Retrieve the hierarchical category tree

-catalog_category.level - Retrieve one level of categories by a website, store view, or parent category

-catalog_category.info - Retrieve the category data

-catalog_category.create - Create a new category

-catalog_category.update - Update a category

-catalog_category.move - Move a category in its tree

-catalog_category.delete - Delete a category

-catalog_category.assignedProducts - Retrieve a list of products assigned to a category

-catalog_category.assignProduct - Assign product to a category

-catalog_category.updateProduct - Update an assigned product

-catalog_category.removeProduct - Remove a product assignment

-cataloginventory_stock_item.list - Retrieve the list of stock data by product IDs

-cataloginventory_stock_item.update - Update the stock data for a list of products


Checkout/Cart Methods:

-cart_coupon.add - Add a coupon code to a quote

-cart_coupon.remove - Remove a coupon code from a quote

-cart_customer.set - Add customer information into a shopping cart

-cart_customer.addresses - Set the customer addresses (shipping and billing) into a shopping cart

-cart_payment.method - Set a payment method for a shopping cart

-cart_payment.list - Get the list of available payment methods for a shopping cart

-cart_product.add - Add one or more products to a shopping cart

-cart_product.update - Update one or more products in a shopping cart

-cart_product.remove - Remove one or more products from a shopping cart

-cart_product.list - Get a list of products in a shopping cart

-cart_product.moveToCustomerQuote - Move one or more products from the quote to the customer shopping cart

-cart_shipping.method - Set a shipping method for a shopping cart

-cart_shipping.list - Retrieve the list of available shipping methods for a shopping cart

-cart.create - Create a blank shopping cart

-cart.order - Create an order from a shopping cart

-cart.info - Get full information about the current shopping cart

-cart.totals - Get all available prices for items in shopping cart, using additional parameters

-cart.license - Get website license agreement


Customer Methods:

-customer_group.list - Allows you to export customer groups from Magento

-customer.list - Retrieve the list of customers

-customer.create - Create a new customer

-customer.info - Retrieve the customer data

-customer.update - Update the customer data

-customer.delete - Delete a required customer

-customer_address.list - Retrieve the list of customer addresses

-customer_address.create - Create a new address for a customer

-customer_address.info - Retrieve the specified customer address

-customer_address.update - Update the customer address

-customer_address.delete - Delete the customer address


Country/Region Methods:

-directory_country.list - Retrieve a list of countries

-directory_region.list - Retrieve a list of regions in a specified country


Orders/Invoices/Shipments Methods:

-X sales_order.list - Retrieve the list of orders using filters

-X sales_order.info - Retrieve the order information

-sales_order.addComment - Add a comment to an order

-sales_order.hold - Hold an order

-sales_order.unhold - Unhold an order

-sales_order.cancel - Cancel an order

-X sales_order_invoice.list - Retrieve a list of invoices using filters

-X sales_order_invoice.info - Retrieve information about the invoice

-X sales_order_invoice.create - Create a new invoice for an order

-sales_order_invoice.addComment - Add a new comment to an invoice

-sales_order_invoice.capture - Capture an invoice

-sales_order_invoice.cancel - Cancel an invoice

-X sales_order_shipment.list - Retrieve a list of shipments using filters

-X sales_order_shipment.info - Retrieve information about the shipment

-X sales_order_shipment.create - Create a new shipment for an order

-sales_order_shipment.addComment - Add a new comment to a shipment

-X sales_order_shipment.addTrack - Add a new tracking number to a shipment

-sales_order_shipment.removeTrack - Remove tracking number from a shipment

-sales_order_shipment.getCarriers - Retrieve a list of allowed carriers for an order

-sales_order_creditmemo.list - Retrieve the list of credit memos by filters

-sales_order_creditmemo.info - Retrieve the credit memo information

-sales_order_creditmemo.create - Create a new credit memo for order

-sales_order_creditmemo.addComment - Add a new comment to the credit memo

-sales_order_creditmemo.cancel - Cancel the credit memo


Store Info Methods:

-X store.info - Get information about a store view

-X store.list - Get the list of store views


Magento Enterprise Methods: (not covered by MagentoApiWrapper)

-storecredit.balance - Retrieve the customer store credit balance information

-storecredit.history - Retrieve the customer store credit history information

-storecredit_quote.setAmount - Set amount from the customer store credit into a shopping cart (quote)

-storecredit_quote.removeAmount - Remove amount from a shopping cart (quote) and increase the customer store credit

-giftcard_customer.info - Receive information about the gift card for a selected customer

-giftcard_customer.redeem - Redeem amount present on the gift card to the store credit

-cart_giftcard.list - Retrieve the list of gift cards used in the shopping cart (quote).

-cart_giftcard.add - Add a gift card to a shopping cart (quote).

-cart_giftcard.remove - Remove a gift card from the shopping cart (quote).

-giftcard_account.create - Create a new gift card

-giftcard_account.list - Get list of available gift cards

-giftcard_account.update - Update a gift card

-giftcard_account.info - Receive full information about selected gift card

-giftcard_account.remove - Remove unnecessary gift card

-giftmessage.setForQuote - Set a gift message for the shopping cart (quote)

-giftmessage.setForQuoteItem - Set a gift message for an item in the shopping cart (quote)

-giftmessage.setForQuoteProduct - Set a gift message for a product in the shopping cart (quote)


## Contributing

This is a very early release, please open issues and I will do my best
to address them in a timely manner.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
