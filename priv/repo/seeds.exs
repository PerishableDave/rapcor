# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rapcor.Repo.insert!(%Rapcor.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rapcor.Repo
alias Rapcor.ClinicianAccounts.Experience

Repo.transaction(fn ->
  Repo.insert!(%Experience{description: "NICU"})
  Repo.insert!(%Experience{description: "PICU"})
  Repo.insert!(%Experience{description: "Adult ICU"})
  Repo.insert!(%Experience{description: "Emergency Room"})
  Repo.insert!(%Experience{description: "Pediatric"})
  Repo.insert!(%Experience{description: "Adult Medical/Surgical"})
end)