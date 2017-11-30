defmodule EventManagerApi.Scheduler do
  @moduledoc false

  use Quantum.Scheduler, otp_app: :event_manager_api
  alias Crontab.CronExpression.Parser
  alias Quantum.Job
  import EventManagerApi.Events, only: [delete_events: 2]

  def create_jobs do
    __MODULE__.new_job()
    |> Job.set_name(:events_termination)
    |> Job.set_overlap(false)
    |> Job.set_schedule(Parser.parse!(get_config()[:events_termination]))
    |> Job.set_task(fn ->
      delete_events(get_config()[:max_events], get_config()[:events_expiration])
    end)
    |> __MODULE__.add_job()
  end

  defp get_config do
    Confex.fetch_env!(:event_manager_api, __MODULE__)
  end
end
