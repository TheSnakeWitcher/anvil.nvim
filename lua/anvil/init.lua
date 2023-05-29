local Job = require("plenary.job")
local util = require("anvil.util")


local M = {
    state = {},
    is_running = false,
}

local default_config = {
    config_file_name = "anvil_conf.json",   -- file where to output anvil config when spawned 
    accounts = 10,                          -- number of accounts to generate and configure
    balance = 10000,                        -- balance of every account
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
    vim.api.nvim_exec_autocmds("User",{pattern = "AnvilStartPre"})

    local args_tbl = {
        "--config-out",M.config.config_file_name,
        "--host",M.config.host,
        "--port",M.config.port,
        "--accounts",M.config.accounts,
        "--balance",M.config.balance,
    }
    args_tbl = util.insert_not_nil_opts(opts,args_tbl)

    Job:new({
        command = "anvil",
        args = args_tbl,
    }):start()
    M.is_running = true
    vim.notify("anvil started")

    vim.api.nvim_exec_autocmds("User",{pattern = "AnvilStartPost", data = {options = args_tbl} })
end

local function get_pid()
    if not M.is_running then return nil end
    return vim.fn.systemlist({"pgrep","anvil"})[1]
end

function M.stop()
    vim.api.nvim_exec_autocmds("User",{pattern = "AnvilStopPre"})

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
    vim.notify("anvil stoped")

    vim.api.nvim_exec_autocmds("User",{pattern = "AnvilStopPost"})
end


local function get_state()
    if not M.is_running then return nil end
    local file = io.open(M.config.config_file_name,"r")
    local file_content = file:read("*a")
    M.state = vim.json.decode(file_content)
end

local function check_state()
    if not vim.tbl_isempty(M.state) then
        return true
    end

    get_state()

    if vim.tbl_isempty(M.state) then
        return false
    else
        return true
    end
end

function M.get_accounts(index)
    if not check_state() then return nil end
    if not index then
        return M.state.available_accounts
    else
        return M.state.available_accounts[index]
    end
end


local function get_account_index(account_address)
    if not account_address then return nil end

    if type(account_address) == "number" then
        return account_address
    end

    for index,account in ipairs(M.state.accounts) do
        if account == account_address then
            return index
        end
    end

    return nil
end

function M.get_private_key(account)
    local index = get_account_index(account)

    if index then
        return M.state.private_keys[index]
    else
        return nil
    end
end

return M
