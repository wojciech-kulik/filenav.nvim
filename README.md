# 🤩 filenav.nvim

A simple navigation between visited files in Neovim.

## Problem

Neovim has a built-in command `:bp` and `:bn` to navigate between buffers.
However, it's not practical to use. If you visit buffers: 1, 2, 3, 4, and jump
to buffer 2, then `:bp` will take you to buffer 1, not buffer 4. This is not
what we want.

There is also `<C-o>` and `<C-i>` to navigate between the jump list entries. However,
it also contains jumps within the same buffer, which is not what we want.

## Solution

`filenav.nvim` provides a simple way to navigate between visited files similar to
the browser's back and forward buttons. It maintains a list of visited files and
allows you to navigate between them.

If you go back to a file and navigate to a new file, all the following files will
be removed from the history.

### Example 1

- You visit files: 1, 2, 3, 4
- You go back to file 2 using keybindings
- You navigate to file 5
- The history will be: 1, 2, 5

### Example 2

- You visit files: 1, 2, 3, 4
- You go back to file 2 using Telescope
- You navigate to file 5
- The history will be: 1, 2, 3, 4, 2, 5

## Installation

```lua
return {
  "wojciech-kulik/filenav.nvim",
  dev = true,
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
