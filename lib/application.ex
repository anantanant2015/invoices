defmodule Invoices do
  use Application

  def start(_start_type, _start_args) do
    Invoices.Supervisor.start_link()
  end
end
