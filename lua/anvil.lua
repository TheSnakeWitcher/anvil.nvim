local Job = require("plenary.job")

local anvil = {}

local defaults = {
    config_file_name = "anvil_conf.json",
    accounts = 15,                          -- number of dev accounts to generate and configure
    balance = 10000,                        -- balance of every dev account
    host = "127.0.0.1",
    port = "8545",
    tracing = true,
    timeout = 45000,                        -- timeout in ms for request to sent remote JSON-RPC
}

function anvil.setup(options)

    anvil.options = vim.tbl_deep_extend("force",options or {},defaults)

    vim.api.nvim_create_user_command("Anvil", anvil.spawn , {})

end

function anvil.spawn()
    Job:new({
        command = 'anvil',
        args = {
            "--config-out",anvil.options.config_file_name,
            "--host",anvil.options.host,
            "--port",anvil.options.port,
            "--accounts",anvil.options.accounts,
            "--balance",anvil.options.balance,
        },
    }):start()
end

return anvil
