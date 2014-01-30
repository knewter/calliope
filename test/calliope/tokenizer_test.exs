defmodule CalliopeTokenizerTest do
  use ExUnit.Case

  import Calliope.Tokenizer

  @haml %s{
!!! 5
%section.container
  %h1= arg
  / %h1 An important inline comment
  /[if IE]
    %h2 An Elixir Haml Parser
  .content
    = arg
    Welcome to Calliope}

  @haml_with_lc %s{
%section
  = lc { id, headline, content } inlist posts do
    %article
      %h1
        %a{href: "#"}= headline
      %p
        = content
}

  test :tokenize_haml_with_lc do
    assert [
      ["%section"],
      ["\t", "= lc ", "{ id, headline, content }", "inlist posts do"],
      ["\t\t", "%article"],
      ["\t\t\t", "%h1"],
      ["\t\t\t\t", "%a", "{href: \"#\"}", "= headline"],
      ["\t\t\t", "%p"],
      ["\t\t\t\t", "= content"]
    ] == tokenize(@haml_with_lc)
  end

  test :tokenize_inline_haml do
    inline = "%div Hello Calliope"
    assert [["%div","Hello Calliope"]] == tokenize(inline)
  end

  test :tokenize_multiline_haml do
    assert [
      ["!!! 5"],
      ["%section", ".container"],
      ["\t", "%h1", "= arg"],
      ["\t", "/ ", "%h1", "An important inline comment"],
      ["\t", "/[if IE]"],
      ["\t\t", "%h2", "An Elixir Haml Parser"],
      ["\t", ".content"],
      ["\t\t", "= arg"],
      ["\t\t", "Welcome to Calliope"]
    ] == tokenize(@haml)
  end

  test :tokenize_line do
    assert [["%section", ".container", ".blue", "{src='#', data='cool'}", "Calliope"]] == tokenize("\n%section.container.blue{src='#', data='cool'} Calliope")
    assert [["%section", ".container", "(src='#', data='cool')", "Calliope"]] == tokenize("\n%section.container(src='#', data='cool') Calliope")
  end

  test :tokenize_identation do
    assert [
        ["%section"],
        ["\t", "%h1", "Calliope"],
        ["\t", "%h2", "Subtitle"],
        ["\t\t", "%section"]
      ] == tokenize_identation [
        ["%section"],
        ["  ", "%h1", "Calliope"],
        ["  ", "%h2", "Subtitle"],
        ["    ", "%section"]
      ], 2
  end

  test :compute_tabs do
    assert 0 == compute_tabs [["aa"]]
    assert 2 == compute_tabs [["aa"], ["  ", "aa"]]
    assert 4 == compute_tabs [["aa"], ["    ", "aa"]]
    assert 2 == compute_tabs [["aa"], ["  ", "aa"], ["    ", "aa"]]
  end

end
