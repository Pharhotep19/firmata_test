defmodule FirmataTest.Analog do
  use GenServer
  require Logger
  @report 1
  @no_report 0

  defmodule State do
    defstruct firmata: nil, channel: nil, value: 0
  end

  def start_link(firmata, channel, name \\ nil) do
    GenServer.start_link(__MODULE__, [firmata, channel], name: name)
  end

  def init([firmata, channel]) do
    #Set our analog channel/pin to "report" which means to report values to this process
    Firmata.Board.report_analog_channel(firmata, channel, @report)
    {:ok, %State{firmata: firmata, channel: channel}}
  end

  def handle_info({:firmata, {:analog_read, channel, value}}, %{channel: s_channel} = state) when channel === s_channel do
    Logger.debug "#{__MODULE__} on #{channel}: #{inspect value}"
    #Update our state with the latest value
    {:noreply, %State{state | value: value}}
  end

end
