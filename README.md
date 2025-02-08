# 🤩 filenav.nvim

A simple navigation between visited files in Neovim.

## Problem

Neovim has a built-in command `:bp` and `:bn` to navigate between buffers.
However, it's not practical to use. If you visit buffers: 1, 2, 3, 4, and jump
to buffer 2 using `:b2`, then `:bp` will take you to buffer 1, not buffer 4. This is not
what we want.

There is also `<C-o>` and `<C-i>` to navigate between the jump list entries. However,
it also contains jumps within the same buffer, which is not what we want.

## Solution

`filenav.nvim` provides a simple way to navigate between visited files similar to
the browser's back and forward buttons. It maintains a list of visited files and
allows you to navigate between them.

### Example 1

- Visit files: 1, 2, 3, 4
- Go back to file 2 using `:FilenavPrev` twice
- Navigate to file 5 using Telescope
- The history will be: 1, 2, 5

### Example 2

- Visit files: 1, 2, 3, 4
- Navigate to file 2 using Telescope
- Navigate to file 5 using Telescope
- The history will be: 1, 2, 3, 4, 2, 5

If you call `:FilenavPrev` you will got back to file 2, then 4, etc.

## Installation

```lua
return {
  "wojciech-kulik/filenav.nvim",
  config = function()
    require("filenav").setup({
      next_file_key = "<M-i>",
      prev_file_key = "<M-o>",
      max_history = 100,
      remove_duplicates = false,
    })
  end,
}
```

## Usage

By default, you can use `<M-i>` and `<M-o>` to navigate between files.

You can also use the following commands:

- `:FilenavPrev` - go back to the previous file
- `:FilenavNext` - go forward to the next file
