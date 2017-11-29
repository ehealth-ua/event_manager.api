defmodule EventManagerApi.ReleaseTasks do
  @start_apps [
    :postgrex,
    :ecto,
    :event_manager_api,
  ]

  def repos, do: Application.get_env(:event_manager_api, :ecto_repos, [])

  def seed do
    IO.puts "Starting dependencies.."
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for myapp
    IO.puts "Starting repos.."
    Enum.each(repos(), &(&1.start_link(pool_size: 1)))

    # Run migrations
    migrate()

    # Signal shutdown
    IO.puts "Success!"
    :init.stop()
  end

  def migrate, do: Enum.each(repos(), &run_migrations_for/1)

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts "Running migrations for #{app}"

    migration_source = migrations_path(app)
    IO.puts "Migrations path: #{migration_source}"
    Ecto.Migrator.run(repo, migration_source, :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
end
