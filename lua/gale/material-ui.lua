local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- Snippets for Material-UI
ls.add_snippets("javascript", {
  -- Import a Material-UI component
  s("muiim", {
    t "import ",
    i(1, "Component"),
    t " from '@mui/material/",
    i(2, "Component"),
    t "';",
  }),

  -- Material-UI Button
  s(
    "muibtn",
    fmt(
      [[
<Button variant="{}" color="{}">
  {}
</Button>
]],
      {
        i(1, "contained"), -- Default value: 'contained'
        i(2, "primary"), -- Default color
        i(0, "Click Me!"), -- Button text
      }
    )
  ),

  -- Material-UI Grid
  s(
    "muigrid",
    fmt(
      [[
<Grid container spacing={}>
  <Grid item xs={}>
    {}
  </Grid>
</Grid>
]],
      {
        i(1, "2"), -- Spacing between grid items
        i(2, "12"), -- Default grid width
        i(0, "Content"), -- Default content
      }
    )
  ),
})
