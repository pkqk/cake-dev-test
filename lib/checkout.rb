class UnexpectedItemInTheBaggingArea < ArgumentError
end

class Promotion
  def add(sku, prices)
  end

  def discount(total)
    0.0
  end
end

class PriceReductionRule < Promotion
  def initialize(sku, min, new_price)
    @sku = sku
    @count = 0
    @new_price = new_price
    @min = min
  end

  def add(sku, prices)
    if sku == @sku
      @count += 1
      if @count >= @min
        prices[@sku] = @new_price
      end
    end
  end
end

class MinSpendDiscount < Promotion
  def initialize(min, discount)
    @min = min
    @discount = discount
  end

  def discount(total)
    if total >= @min
      @discount * total
    else
      0.0
    end
  end
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
    @prices = PRODUCTS.dup
  end

  def scan(sku)
    raise UnexpectedItemInTheBaggingArea unless @prices[sku]
    @items << sku
    STDOUT.print("\a"); STDOUT.flush
    @promotional_rules.each { |rule| rule.add(sku, @prices) }
  end

  def total
    gross = @items.inject(0.0) do |total, sku|
      total + @prices[sku]
    end
    discounts = @promotional_rules.inject(0.0) { |discount, rule| discount + rule.discount(gross) }
    (gross - discounts).round(2)
  end
end
