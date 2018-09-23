defmodule Rapcor.Registry.Request.Enums do
  import EctoEnum

  defenum RequestStatus, open: 0, fulfilled: 1, cancelled: 2, closed: 3
end
