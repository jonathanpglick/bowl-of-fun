defmodule ShortcodeTest do
  use ExUnit.Case
  doctest Shortcode

  test "greets the world" do
    assert Shortcode.hello() == :world
  end
end
