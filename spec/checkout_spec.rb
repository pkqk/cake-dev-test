require 'checkout'

describe Checkout do
  price_expectations = [
    [%w[001 002 003], 66.78],
    [%w[001 003 001], 36.95],
    [%w[001 002 001 003], 73.76]
  ]

  price_expectations.each do |skus, total|
    it "finds a total of £#{total} for products #{skus.join(', ')}" do
      fail
    end
  end
end
