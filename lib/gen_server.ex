defmodule Invoices.Server do
  use GenServer

  # client
  def start_link(
        initial_state \\ %{refs: %{}, products: [], offers: []},
        init_args \\ [name: :store]
      ) do
    GenServer.start_link(__MODULE__, initial_state, init_args)
  end

  def perform(identifier, :call, args) do
    GenServer.call(identifier, args)
  end

  def perform(identifier, :cast, args) do
    GenServer.cast(identifier, args)
  end

  # server callbacks
  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call(args, _from, state) do
    transform(:reply, args, state)
  end

  @impl true
  def handle_cast(args, state) do
    transform(:noreply, args, state)
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    transform(:noreply, %{action: :delete_ref, data: ref}, state)
  end

  @impl true
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message in KV.Registry: #{inspect(msg)}")
    transform(:noreply, %{action: :unknown, data: msg}, state)
  end

  ## Server callbacks

  def transform(type, args, state) do
    case args.action do
      :add_product ->
        {type,
         put_in(state.products, [Invoices.Helper.define_new_product(args.data) | state.products])}

      :add_offer ->
        {type,
         put_in(state.offers, [Invoices.Helper.define_new_offer(args.data) | state.offers])}

      :delete_ref ->
        new_refs = Map.pop(state.refs, args.data)
        {type, put_in(state.refs, new_refs)}

      :create_bucket ->
        {:ok, new_bucket} = Invoices.Bucket.start_link()
        new_ref = Process.monitor(new_bucket)
        new_refs = Map.put(state.refs, args.data, {new_bucket, new_ref})
        {type, new_bucket, put_in(state.refs, new_refs)}

      :update_bucket ->
        {item_code, bucket_name} = args.data
        {bucket, _ref} = Map.get(state.refs, bucket_name)
        {type, Invoices.Bucket.put(item_code, bucket), state}

      :delete_bucket ->
        {bucket, _ref} = Map.get(state.refs, args.data)
        {type, Invoices.Bucket.get(bucket), state}

      :get_bucket ->
        {bucket, _ref} = Map.get(state.refs, args.data)
        {type, Invoices.Bucket.get(bucket), state}

      :lookup ->
        {type, Map.get(state, args.data), state}

      _ ->
        {type, state}
    end
  end
end
