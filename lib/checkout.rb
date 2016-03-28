class UnexpectedItemInTheBaggingArea < ArgumentError
end

class Checkout
  PRODUCTS = {
    "001" => 9.25,
    "002" => 45.00,
    "003" => 19.95
  }

  def initialize(promotional_rules)
    @promotional_rules = promotional_rules || []
    @items = []
  end

  def scan(sku)
    raise UnexpectedItemInTheBaggingArea unless PRODUCTS[sku]
    @items << sku
    @promotional_rules.each { |rule| rule.add(sku) }
  end

  def total
    gross = @items.inject(0.0) do |total, sku|
      total + PRODUCTS[sku]
    end
    discounts = @promotional_rules.inject(0.0) { |discount, rule| discount + rule.discount }
    gross - discounts
  end
end
