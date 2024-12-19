defmodule Invoices.Product do
  defstruct [:name, :code, :price]

  @products []

  # Macro to define a product
  defmacro add_new_product(name, code, price) do
    quote do
      @products [
        %Product{name: unquote(name), code: unquote(code), price: unquote(price)} | @products
      ]
    end
  end

  def list_products do
    @products
  end
end
