defmodule Chain do
  defstruct(
    next_node: nil,
    count: 1000000
  )

  def start_link(next_node) do
    spawn_link(Chain, :message_loop, [%Chain{next_node: next_node}])
    |> Process.register(:chainer)
  end

  def message_loop(%Chain{count: 0}) do
    IO.puts("done")
  end

  def message_loop(state = %Chain{}) do
    receive do
      {:trigger, list} ->
        #IO.inspect(list)
        send({:chainer, state.next_node}, {:trigger, [node() | Enum.take(list, 100)]})
    end

    message_loop(%Chain{state | count: state.count - 1})
  end
end
