defmodule CalliopeRenderTest do
  use ExUnit.Case

  import Calliope.Render

  @haml %s{
!!! 5
%section.container{class: "blue"}
  %article
    %h1= arg
    / %h1 An important inline comment
    /[if IE]
      %h2 An Elixir Haml Parser
    #main.content
      Welcome to Calliope}

  @html Regex.replace(%r/(^\s*)|(\s+$)|(\n)/m, %s{
    <!DOCTYPE html>
    <section class="container blue">
      <article>
        <h1>Calliope</h1>
        <!-- <h1>An important inline comment</h1> -->
        <!--[if IE]> <h2>An Elixir Haml Parser</h2> <![endif]-->
        <div id="main" class="content">
          Welcome to Calliope
        </div>
      </article>
    </section>
  }, "")

  @haml_with_args "= arg"
  @haml_with_args_in_attributes "%a{href: url}= name"

  test :render do
    assert @html == render @haml, [ arg: "Calliope" ]
  end

  test :render_with_params do
    assert "Calliope" == render @haml_with_args, [ arg: "Calliope" ]
  end

  test :render_with_params_inside_attribute_value do
    assert "<a href='http://slashdot.org'>Slashdot</a>" == render @haml_with_args_in_attributes, [ url: "http://slashdot.org", name: "Slashdot" ]
  end
end
