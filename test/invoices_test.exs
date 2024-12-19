defmodule InvoicesTest do
  use ExUnit.Case
  doctest Invoices

  test "greets the world" do
    assert Invoices.hello() == :world
  end
end
