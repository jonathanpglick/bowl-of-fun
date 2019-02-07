defmodule Shortcode do
  defdelegate get_next(), to: Shortcode.Worker
end
