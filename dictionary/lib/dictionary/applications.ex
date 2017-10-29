defmodule Dictionary.Application do
    
    use Application

    def start(_type, _args) do

        children = [
            %{
                id: Dictionary_Agent,
                start: {Dictionary.Agent, :start_link, []}
            }
        ]

        options = [
            strategy: :one_for_one,
            max_restarts: 3,
            max_seconds: 5,
        ]

        Supervisor.start_link(children, options)
    end

end