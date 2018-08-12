defmodule Rapcor.Registry.Request.Enums do
  import EctoEnum

  defenum RequestStatus, pending: 0, open: 1, fulfilled: 2, cancelled: 3
end
