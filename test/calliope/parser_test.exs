defmodule CalliopeParserTest do
  use ExUnit.Case

  import Calliope.Parser

  @tokens [
      ["!!! 5"],
      ["%section", ".container", ".blue"],
      ["\t", "%h1", "= arg"],
      ["\t", "/", "%h1", "An important inline comment"],
      ["\t", "/[if IE]"],
      ["\t\t", "%h2", "An Elixir Haml Parser"],
      ["\t", "#main", ".content"],
      ["\t\t", "= arg"],
      ["\t\t", " Welcome to Calliope"],
      ["%section", ".container", "(data-a: 'calliope', data-b: 'awesome')"],
      ["\t", "%img", ".one", "{id: 'main_image', class: 'two three', src: '#'}"],
    ]

  @tokens_lc [
      ["%section"],
      ["\t", "= lc ", "{ id, headline, content }", "inlist posts do"],
      ["\t\t", "%article"],
      ["\t\t\t", "%h1"],
      ["\t\t\t\t", "%a", "{href: '#'}", "= headline"],
      ["\t\t\t", "%p"],
      ["\t\t\t\t", "= content"]
    ]

  @parsed_lc [
      [ tag: "section" ],
      [ indent: 1, comprehension: "lc { id, headline, content } inlist posts do" ],
      [ indent: 2, tag: "article" ],
      [ indent: 3, tag: "h1" ],
      [ indent: 4, tag: "a", attributes: "href='#'", script: " headline"  ],
      [ indent: 3, tag: "p" ],
      [ indent: 4, script: " content" ]
    ]

  @parsed_tokens [
      [ doctype: "!!! 5" ],
      [ tag: "section", classes: ["container", "blue"] ],
      [ indent: 1, tag: "h1", script: " arg" ],
      [ indent: 1, comment: "!--", tag: "h1", content: "An important inline comment" ],
      [ indent: 1, comment: "!--[if IE]" ],
      [ indent: 2, tag: "h2", content: "An Elixir Haml Parser" ],
      [ indent: 1, id: "main", classes: ["content"] ],
      [ indent: 2, script: " arg" ],
      [ indent: 2, content: "Welcome to Calliope" ],
      [ tag: "section", classes: ["container"], attributes: "data-a='calliope' data-b='awesome'" ],
      [ indent: 1, tag: "img", id: "main_image", classes: ["one", "two", "three"], attributes: "src='#'" ]
    ]

  @nested_tree [
      [ doctype: "!!! 5" ],
      [ tag: "section", classes: ["container", "blue"], children: [
          [ indent: 1, tag: "h1", script: " arg" ],
          [ indent: 1, comment: "!--", tag: "h1", content: "An important inline comment" ],
          [ indent: 1, comment: "!--[if IE]", children: [
              [ indent: 2, tag: "h2",content: "An Elixir Haml Parser"]
            ]
          ],
          [ indent: 1, id: "main", classes: ["content"], children: [
              [ indent: 2, script: " arg" ],
              [ indent: 2, content: "Welcome to Calliope" ]
            ]
          ],
        ],
      ],
      [ tag: "section", classes: ["container"], attributes: "data-a='calliope' data-b='awesome'",children: [
          [ indent: 1, tag: "img", id: "main_image", classes: ["one", "two", "three"], attributes: "src='#'"]
        ]
      ]
    ]

  test :parse do
    assert @nested_tree == parse @tokens
  end

  test :build_tree do
    assert @nested_tree == build_tree @parsed_tokens
  end

  defp tokens(n), do: line(@tokens, n)

  defp parsed_tokens(n), do: Enum.sort line(@parsed_tokens, n)

  defp parsed_line_tokens(tokens), do: Enum.sort parse_line(tokens)

  defp line(list, n), do: Enum.fetch!(list, n)

end
