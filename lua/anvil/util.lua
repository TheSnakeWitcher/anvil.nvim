local M = {}

M.check_executable = function(executable)
    if not vim.fn.executable(executable) then
        vim.health.report_error(executable .. " missing")
    else
        vim.health.report_ok(executable .. " ok")
    end
end

local function insert_with_key(key,value,tbl)
    if not value then return tbl end
    table.insert(tbl,unpack({key,value}))
end

M.insert_opts = function(opts,tbl)
    tbl = insert_with_key(
        "--fork-url",
        opts.fork_url,
        tbl
    )
    tbl = insert_with_key(
        "--fork-block-number",
        opts.fork_block_number,
        tbl
    )
    tbl = insert_with_key(
        "--fork-chain-number",
        opts.fork_chain_id,
        tbl
    )
    return tbl
end

return M
