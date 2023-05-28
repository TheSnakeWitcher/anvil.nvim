local util = require("anvil.util")

local M = {}

M.check = function()
    vim.health.report_start("anvil.nvim report")
    util.check_executable("anvil")
    util.check_executable("pgrep")
end

return M
