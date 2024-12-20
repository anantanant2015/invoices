defmodule Invoices.Bucket do
  use Agent

  @doc """
  Starts a new bucket.
  """
  def start_link(opts \\ [name: :bucket]) do
    Agent.start_link(fn -> [] end, opts)
  end

  @doc """
  Gets a value from the `bucket`.
  """
  def get(bucket \\ :bucket) do
    Agent.get(bucket, & &1)
  end

  @doc """
  Puts the `item` in the `bucket`.
  """
  def put(item, bucket \\ :bucket) do
    Agent.update(bucket, &[item | &1])
  end

  @doc """
  Deletes `item` from `bucket`.
  """
  def delete(item, bucket \\ :bucket) do
    Agent.get_and_update(bucket, &List.delete(&1, item))
  end
end
