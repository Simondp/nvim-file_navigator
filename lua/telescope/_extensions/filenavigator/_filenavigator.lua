local pickers = require "telescope.pickers"
local fileutil = require"lib.fileutil"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local previewers = require("telescope.previewers")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local M={}
local function get_entries(path)
  local files = vim.split(vim.fn.globpath(path,'*'),'\n')
  local results={};
  for key,value in pairs(files) do
		results[key] = {string.match(value,"[^/]*$"),value}
  end
  table.insert(results,{"..",".."})
  return results
end

local function make_entry(entry)
	return
	{
		value = entry,
		display = entry[1],
		filename = entry[2],
		ordinal = entry[2]
	}
end


-- to execute the function

local ent = get_entries(r)

local function Action(prompt_bufnr, map)
		actions.select_default:replace(function() 
				local entry = action_state.get_selected_entry()
				if(fileutil.isdirectory(entry["filename"])) then
					local entries = get_entries(entry["filename"])
					local current_picker = action_state.get_current_picker(prompt_bufnr)
					current_picker:refresh(finders.new_table{entry_maker = make_entry,results = entries}, {})
				else
					actions.close(prompt_bufnr)
					vim.cmd('e'..entry["filename"]) 
				end

		end)
	return true
end

local function navigate(opts,entries)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "File navigater",
    finder = finders.new_table {
		entry_maker = make_entry,
		results = entries,
    },
	attach_mappings = Action,
    sorter = conf.generic_sorter(opts),
	previewer = previewers.vim_buffer_cat.new(opts)
  }):find()
end

function M.do_navigate()
	local path = vim.fn.expand('%:p') 
	local ending = vim.fn.expand('%:t')
	local r = string.gsub(path,ending,"")
	local entries = get_entries(r)
	navigate(nil,entries);
end

return M
