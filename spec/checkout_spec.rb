require 'checkout'

describe Checkout do
  price_expectations = [
    [%w[001 002 003], 66.78],
    [%w[001 003 001], 36.95],
    [%w[001 002 001 003], 73.76]
  ]
  promotional_rules = [
    PriceReductionRule.new("001", 2, 8.50),
    MinSpendDiscount.new(60, 0.1)
  ]

  price_expectations.each do |skus, total|
    it "finds a total of £#{total} for products #{skus.join(', ')}" do
      co = Checkout.new(promotional_rules)
      skus.each {|sku| co.scan(sku) }
      expect(co.total).to eql(total)
    end
  end

  it "handles an unknown sku" do
    co = Checkout.new(promotional_rules)
    expect{ co.scan("missing") }.to raise_error(UnexpectedItemInTheBaggingArea)
  end
end
