# Constants help us "name" special numbers

CLEARANCE_ITEM_DISCOUNT_RATE = 0.20
BIG_PURCHASE_DISCOUNT_RATE = 0.10

def find_item_by_name_in_collection(name, collection)

  i=0
  while i < collection.length
    if name == collection[i][:item]
      return collection[i]
    end
  i += 1
  end
  nil
end


def consolidate_cart(cart)
  unique_cart = []
  hash = Hash.new(0)

  i=0
  while i < cart.length
    hash[cart[i]] += 1
    i += 1
  end

  hash.each do |k,v|
    k[:count] = v
    unique_cart.push(k)
  end
  
  unique_cart
end



# Don't forget, you can make methods to make your life easy!

# def mk_coupon_hash(c)
#   rounded_unit_price = (c[:cost].to_f * 1.0 / c[:num]).round(2)
#   {
#     :item => "#{c[:item]} W/COUPON",
#     :price => rounded_unit_price,
#     :count => c[:num]
#   }
# end

# A nice "First Order" method to use in apply_coupons

# def apply_coupon_to_cart(matching_item, coupon, cart)
#   matching_item[:count] -= coupon[:num]
#   item_with_coupon = mk_coupon_hash(coupon)
#   item_with_coupon[:clearance] = matching_item[:clearance]
#   cart << item_with_coupon
# end

def apply_coupons(cart, coupons)
  i=0
  while i < coupons.length
    coupon = coupons[i][:item]
    # iterate thru coupons & check if the item is in the cart
    coupon_item = find_item_by_name_in_collection(coupon, cart)
    # if !!coupon_item == true meaining coupon item found in the cart and qty is valid (> qty specified in coupon) then adjust qty

    if !!coupon_item && (coupon_item[:count] >= coupons[i][:num])
      coupon_item[:count] = coupon_item[:count] - coupons[i][:num]
      coupon_applied_item =  mk_coupon_hash(coupons[i])
      coupon_applied_item[:clearance] = coupon_item[:clearance]
      cart.push(coupon_applied_item)
    end
    i+= 1
  end
  cart
end



def apply_clearance(cart)
  i=0
  while i < cart.length
    if cart[i][:clearance] == true
      new_price = (cart[i][:price] *= 0.8).round(2)
      cart[i][:price] = new_price
    end
    i += 1
  end
  cart
end




def checkout(cart, coupons)
  total = 0
  i = 0

  ccart = consolidate_cart(cart)
  apply_coupons(ccart, coupons)
  apply_clearance(ccart)

  while i < ccart.length do
    total += items_total_cost(ccart[i])
    i += 1
  end

  total >= 100 ? total * (1.0 - BIG_PURCHASE_DISCOUNT_RATE) : total
end

# Don't forget, you can make methods to make your life easy!

def items_total_cost(i)
  i[:count] * i[:price]
end