defmodule FirmataTest.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(FirmataTest.Board, ["/dev/ttyUSB1"]),
    ]

    opts = [strategy: :one_for_one, name: FirmataTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
