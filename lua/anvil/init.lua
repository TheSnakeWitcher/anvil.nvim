local Job = require("plenary.job")
local util = require("chisel.util")


local M = {
    state = {},
    is_running = false,
}

local default_config = {
    config_file_name = "anvil_conf.json",   -- file where to output anvil config when spawned 
    accounts = 10,                          -- number of dev accounts to generate and configure
    balance = 10000,                        -- balance of every dev account
    host = "127.0.0.1",
    port = "8545",
    tracing = true,
    timeout = 45000,                        -- timeout in ms for request to sent remote JSON-RPC
}

function M.setup(user_config)
    M.config = vim.tbl_deep_extend("force",default_config,user_config or {})
end

-- optional: fork_url , fork_block_number , fork_chain_id
function M.start(opts)
    local args_tbl = {
        "--config-out",M.config.config_file_name,
        "--host",M.config.host,
        "--port",M.config.port,
        "--accounts",M.config.accounts,
        "--balance",M.config.balance,
    }
    args_tbl = util.insert_opts(opts,args_tbl)

    Job:new({
        command = "anvil",
        args = args_tbl,
    }):start()
    M.is_running = true
end

local function get_pid()
    if not M.is_running then return nil end
    return vim.fn.systemlist({"pgrep","anvil"})[1]
end

function M.stop()
    local anvil_pid = get_pid()
    if not anvil_pid then
        vim.notify("anvil not runnig")
        return
    end

    Job:new({
        command = "kill",
        args = { anvil_pid },
    }):start()
    M.is_running = false

end

function M.get_state()
    if not M.is_running then return nil end
    local file = io.open(M.config.config_file_name,"r")
    local file_content = file:read("*a")
    M.state = vim.json.decode(file_content)
end

function M.get_accounts(index)

    if vim.tbl_isempty(M.state) then
        M.get_state()
    end
    if vim.tbl_isempty(M.state) then return nil end


    if not index then
        return M.state.accounts
    else
        return M.state.accounts[index]
    end

end

function M.get_account_index(account_address)
    for index,account in ipairs(M.state.accounts) do
        if account == account_address then
            return index
        end
    end
    return nil
end

function M.get_private_key(account_address)
    local index = M.get_account_index(account_address)
    if index then
        return M.state.private_keys[index]
    else
        return nil
    end
end

return M
