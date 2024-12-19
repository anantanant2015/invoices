defmodule InvoicesTest do
  use ExUnit.Case
  alias Invoices.Helper

  @baskets
  %{
    all_tea_combo: [["GR1", "SR1", "GR1", "GR1", "CF1"], "£22.45"],
    tea_only: [["GR1", "GR1"], "£3.11"],
    tea_berry: [["SR1", "SR1", "GR1", "SR1"], "£16.61"],
    all_coffee_combo: [["GR1", "CF1", "SR1", "CF1", "CF1"], "£30.57"]
  }

  test "calculate price with all products and has combo tea offer" do
    [products, basket_price] = Map.get(@basket, :all_tea_combo)
    assert basket_price != Helper.calculate_price(products, :without_offers)
    assert basket_price == Helper.calculate_price(products, :with_offers)
  end

  test "calculate price with tea only and has offer" do
    [products, basket_price] = Map.get(@basket, :tea_only)
    assert basket_price != Helper.calculate_price(products, :without_offers)
    assert basket_price == Helper.calculate_price(products, :with_offers)
  end

  test "calculate price with tea, berry and has berry combo offer" do
    [products, basket_price] = Map.get(@basket, :tea_berry)
    assert basket_price != Helper.calculate_price(products, :without_offers)
    assert basket_price == Helper.calculate_price(products, :with_offers)
  end

  test "calculate price with all and has coffee combo offer" do
    [products, basket_price] = Map.get(@basket, :all_coffee_combo)
    assert basket_price != Helper.calculate_price(products, :without_offers)
    assert basket_price == Helper.calculate_price(products, :with_offers)
  end
end
