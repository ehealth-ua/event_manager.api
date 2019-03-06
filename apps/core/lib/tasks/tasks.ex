defmodule Core.ReleaseTasks do
  @moduledoc false

  alias Ecto.Migrator

  def repos, do: Application.get_env(:core, :ecto_repos, [])

  def migrate do
    migrations_dir = Application.app_dir(:core, "priv/repo/migrations")
    load_app()

    repo = Core.Repo
    repo.start_link()

    Ecto.Migrator.run(repo, migrations_dir, :up, all: true)

    System.halt(0)
    :init.stop()
  end

  defp load_app do
    start_applications([:logger, :postgrex, :ecto, :ecto_sql])
    Application.load(:core)
  end

  defp start_applications(apps) do
    Enum.each(apps, fn app ->
      {_, _message} = Application.ensure_all_started(app)
    end)
  end
end
