defmodule Dictionary.Agent do
    alias Dictionary.WordList

    @me __MODULE__

    def child_spec(opts) do
        %{
            id: @me,
            start: {@me, :start_link, [opts]},
            type: :worker,
            restart: :permanent,
            shutdown: 500
        }
    end

    def start_link() do
        Agent.start_link(fn() -> WordList.word_list() end, name: @me)
    end

    def random_word() do
        Agent.get(@me, fn(state) -> WordList.random_word(state) end)
    end
end