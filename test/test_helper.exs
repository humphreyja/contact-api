ExUnit.start

Mix.Task.run "ecto.create", ~w(-r ContactApi.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r ContactApi.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(ContactApi.Repo)

