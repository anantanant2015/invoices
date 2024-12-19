defmodule Invoices.Offer do
  defstruct [:type, :target, :value, :discount_price]

  @offers []

  # Macro to define an offer
  defmacro add_new_offer(type, target, value, discount_price) do
    quote do
      @offers [
        %Offer{
          type: unquote(type),
          target: unquote(target),
          value: unquote(value),
          discount_price: unquote(discount_price)
        }
        | @offers
      ]
    end
  end

  def list_offers do
    @offers
  end
end
