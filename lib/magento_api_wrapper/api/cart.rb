module MagentoApiWrapper
  class CartApi < MagentoApiWrapper::Api
    #Mage_Checkout
    #TODO:
    #-cart_coupon.add - Add a coupon code to a quote
    #-cart_coupon.remove - Remove a coupon code from a quote
    #-cart_customer.set - Add customer information into a shopping cart
    #-cart_customer.addresses - Set the customer addresses (shipping and billing) into a shopping cart
    #-cart_payment.method - Set a payment method for a shopping cart
    #-cart_payment.list - Get the list of available payment methods for a shopping cart
    #-cart_product.add - Add one or more products to a shopping cart
    #-cart_product.update - Update one or more products in a shopping cart
    #-cart_product.remove - Remove one or more products from a shopping cart
    #-cart_product.list - Get a list of products in a shopping cart
    #-cart_product.moveToCustomerQuote - Move one or more products from the quote to the customer shopping cart
    #-cart_shipping.method - Set a shipping method for a shopping cart
    #-cart_shipping.list - Retrieve the list of available shipping methods for a shopping cart
    #-cart.create - Create a blank shopping cart
    #-cart.order - Create an order from a shopping cart
    #-cart.info - Get full information about the current shopping cart
    #-cart.totals - Get all available prices for items in shopping cart, using additional parameters
    #-cart.license - Get website license agreement
  end
end
