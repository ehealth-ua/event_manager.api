defmodule Core.Scheduler do
  @moduledoc false

  use Quantum.Scheduler, otp_app: :core
  alias Crontab.CronExpression.Parser
  alias Quantum.Job
  alias Quantum.RunStrategy.Local
  import Core.Events, only: [delete_events: 2]

  def create_jobs do
    __MODULE__.new_job()
    |> Job.set_name(:events_termination)
    |> Job.set_overlap(false)
    |> Job.set_schedule(Parser.parse!(get_config()[:events_termination]))
    |> Job.set_task(fn ->
      delete_events(get_config()[:max_events], get_config()[:events_expiration])
    end)
    |> Job.set_run_strategy(%Local{})
    |> __MODULE__.add_job()
  end

  defp get_config do
    Confex.fetch_env!(:core, __MODULE__)
  end
end
