local M = {}

local fn = require('mql_compile.functions')
local opt = require('mql_compile.options')
local cmp = require('mql_compile.compile')

function M.create_commands()
   -- :MQLCompileSetSourc
   vim.api.nvim_create_user_command(
      "MQLCompileSetSource",
      function(opts)
         M.set_source_path(opts.args ~= "" and opts.args or nil)
      end,
      { nargs = "?" }
   )

   -- :MQLCompile
   vim.api.nvim_create_user_command(
      "MQLCompile",
      function(opts)
         cmp.compile(opts.args ~= "" and opts.args or nil)
      end,
      { nargs = "?" }
   )

   -- :MQLCompilePrintOptions
   vim.api.nvim_create_user_command(
      "MQLCompilePrintOptions",
      function()
         print(vim.inspect(opt._opts))
      end,
      { nargs = 0 }
   )

end


function M.set_source_path(path)
   local msg = ''

   if (path == 'v:null' or path == nil or path == '') then
      path = vim.api.nvim_buf_get_name(0) -- get current file path
   end

   path = vim.fn.expand(path) -- for % ~ 
   local extension = path:match('%.(.*)$')

   if not extension then
       msg = 'Invalid path: no extension found.'
       fn.notify(msg, vim.log.levels.ERROR)
       return
   end

   -- Determin mql by extension
   if extension == opt._opts.mql5.extension then
       opt._opts.mql5.source_path = path
       msg = 'MQL5 source path set to: ' .. path
       fn.notify(msg, vim.log.levels.INFO)
   elseif extension == opt._opts.mql4.extension then
       opt._opts.mql4.source_path = path
       msg = 'MQL4 source path set to: ' .. path
       fn.notify(msg, vim.log.levels.INFO)
   else
       msg = 'Unknown file type: ' .. extension .. ". Type must be in 'opts.[mql5/mql4].extension'."
       fn.notify(msg, vim.log.levels.ERROR, { titile = 'mql-compiler' })
       return
   end
end



return M