local Job = require("plenary.job")

local anvil = {}

local defaults = {
    config_file_name = "anvil_conf.json",
    accounts = 10,
    balance = 10000,
    host = "127.0.0.1",
    port = "8545",
}

function anvil.setup(options)

    anvil.options = vim.tbl_deep_extend("force",options or {},defaults)

    vim.api.nvim_create_user_command("Anvil", anvil.spawn , {})

end

function anvil.spawn()
    Job:new({
        command = 'anvil',
        args = {
            "--config-out",anvil.options.config_file_name
        },
    }):start()
end

return anvil
