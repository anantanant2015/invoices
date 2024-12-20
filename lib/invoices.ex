defmodule Invoices.Service do
  def add_new_product(name, code, price, store \\ :store) do
    Invoices.Server.perform(store, :cast, %{action: :add_product, data: {name, code, price}})
  end

  def add_new_offer(type, target, value, discount_price, store \\ :store) do
    Invoices.Server.perform(store, :cast, %{
      action: :add_offer,
      data: {type, target, value, discount_price}
    })
  end

  def create_bucket(name \\ :bucket, store \\ :store) do
    Invoices.Server.perform(store, :call, %{action: :create_bucket, data: name})
  end

  def get_bucket(name \\ :bucket, store \\ :store) do
    Invoices.Server.perform(store, :call, %{action: :get_bucket, data: name})
  end

  def update_bucket(item_code, name \\ :bucket, store \\ :store) do
    Invoices.Server.perform(store, :call, %{action: :update_bucket, data: {item_code, name}})
  end

  def list_products(store \\ :store) do
    Invoices.Server.perform(store, :call, %{action: :lookup, data: :products})
  end

  def list_offers(store \\ :store) do
    Invoices.Server.perform(store, :call, %{action: :lookup, data: :offers})
  end

  def calculate_price(offer_info \\ :with_offers, name \\ :bucket, store \\ :store) do
    Invoices.Server.perform(store, :call, %{action: :get_bucket, data: name})
    |> Invoices.Helper.calculate_price(offer_info)
  end
end
