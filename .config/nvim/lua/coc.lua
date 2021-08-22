local v = require("utils")

v.v.g.coc_global_extensions = {
    "coc-highlight", "coc-json", "coc-pyright", "coc-rust-analyzer", "coc-snippets", "coc-tsserver", "coc-lua",
    "coc-vimlsp", "coc-prettier", "coc-go", "coc-eslint"
}

-- Highlight the symbol and its references when holding the cursor.
v.autocmd("CursorHold", "*", "silent call CocActionAsync('highlight')")
v.autocmd("User", "CocTerminalOpen", function() v.cmd.resize("+20") end)

-- Add `:Format` command to format current buffer.
v.cmd["Format"] = function() return v.cmd.CocAction("format") end

-- Add `:OR` command for organize imports of the current buffer.
v.cmd["OR"] = function() return v.cmd.CocAction("runCommand", "editor.action.organizeImport") end
