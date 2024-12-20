defmodule Invoices.Helper do
  def calculate_price(basket, :without_offers) do
    Invoices.Service.list_products()
    |> Enum.filter(fn product -> product.code in basket end)
    |> Enum.reduce(0.0, fn product, acc -> acc + product.price end)
  end

  def calculate_price(basket, :with_offers) do
    products = Invoices.Service.list_products()
    offers = Invoices.Service.list_offers()

    basket
    |> Enum.reduce({0.0, basket}, fn code, {acc, remaining_codes} ->
      product = Enum.find(products, fn p -> p.code == code end)
      offer = Enum.find(offers, fn o -> o.target == code or String.contains?(o.target, code) end)

      cond do
        offer && offer.type == :quantity ->
          # Apply quantity-based offer
          num_products = Enum.count(remaining_codes, &(&1 == product.code))
          num_full_sets = div(num_products, offer.value)
          discount = num_full_sets * offer.discount_price
          {acc + product.price * num_products - discount, List.delete(remaining_codes, code)}

        offer && offer.type == :combo ->
          # Apply combo offer
          combo_count =
            Enum.count(remaining_codes, fn code -> String.contains?(offer.target, code) end)

          if combo_count >= offer.value do
            {acc + offer.discount_price, List.delete(remaining_codes, code)}
          else
            {acc + product.price, remaining_codes}
          end

        true ->
          {acc + product.price, remaining_codes}
      end
    end)
    |> elem(0)
  end

  def define_new_product({name, code, price}) do
    [%Invoices.Product{name: name, code: code, price: price}]
  end

  def define_new_offer({type, target, value, discount_price}) do
    [
      %Invoices.Offer{
        type: type,
        target: target,
        value: value,
        discount_price: discount_price
      }
    ]
  end
end
