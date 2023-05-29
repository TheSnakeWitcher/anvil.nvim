# Anvil.nvim


Small plugin to more conveniently/easily interact with
[anvil](https://github.com/foundry-rs/foundry/tree/master/anvil) from
[foundry](https://github.com/foundry-rs/foundry) toolkit
inside neovim. Any contributions are welcome and appreciated.


# Index


1. [Installation](#Installation)
2. [Configuration](#Configuration)
3. [Documentation](#Documentation)
4. [License](#License)


# Installation


Install using your prefered package manager. Next code
snippet corresponds to packer. This plugin requires
`pgrep` installed.

```lua
use "TheSnakeWitcher/anvil.nvim"
```


# Configuration


Anvil.nvim doesn't register by default commands or keybindings so
you can personalize to whatever suits you. This section comes with
some configurations recipes/recommendations/samples.

### Options

Default configuration options next.

```lua
require('anvil').setup({

    config_file_name = "anvil_conf.json",   -- file where to output anvil config when spawned 
    accounts = 10,                          -- number of accounts to generate and configure
    balance = 10000,                        -- balance of every account
    host = "127.0.0.1",
    port = "8545",
    tracing = true,
    timeout = 45000,                        -- timeout in ms for request to sent remote JSON-RPC

})
```

### Commands

```lua
local anvil = require("anvil")

vim.api.nvim_create_user_command( "AnvilStart", anvil.start , { desc = "starts a new anvil instance" })

vim.api.nvim_create_user_command("AnvilStop", anvil.stop , { desc = "stop a running anvil instance"})

vim.api.nvim_create_user_command("AnvilStatus", function()
    if anvil.is_running then
        vim.notify("anvil running")
    else
        vim.notify("anvil not running")
    end
end, { desc = "Check if an anvil instance is running"})
```

### Autocommands

```lua
local anvil = require("anvil")

local anvil_augroup = vim.api.nvim_create_augroup("Anvil",{clear = false})

vim.api.nvim_create_autocmd("VimLeave",{
    group = anvil_augroup,
    desc = "avoid leave without stoping anvil",
    callback = function() anvil.stop() end,
})
```


# Documentation


See `anvil`


# License


MIT
