-- Full command glossary. Space is the leader, written here as SPC.
-- Keep this list next to lua/mapping/*.lua. A mapping that is not here
-- will not show up on the start screen.

local groups = {
	{
		title = "Start here",
		rows = {
			{ "SPC h h", "Open this glossary" },
			{ "SPC t", "Open Telescope (every finder)" },
			{ "SPC t h", "Pick a color theme" },
			{ ":checkhealth", "See what is missing" },
		},
	},
	{
		title = "Files and search",
		rows = {
			{ "SPC f f", "Find a file by name" },
			{ "SPC f o", "Recent files" },
			{ "SPC f w", "Search text in the project" },
			{ "SPC b m", "Bookmarks (marks)" },
			{ "SPC t f", "Find files" },
			{ "SPC t t", "Live search in the project" },
			{ "SPC t s", "Search the word under the cursor" },
			{ "SPC n", "File tree" },
			{ "SPC s s", "Jump to two characters on screen" },
		},
	},
	{
		title = "Save, quit, edit",
		rows = {
			{ "SPC w", "Save the file" },
			{ "SPC q", "Quit this window" },
			{ "SPC f", "Format the file" },
			{ "SPC a w", "Toggle autosave" },
			{ "SPC R", "Replace in the whole file" },
			{ "u", "Undo" },
			{ "U", "Redo" },
			{ "SPC r", "Insert a color" },
			{ "SPC x", "Run or preview the current file" },
		},
	},
	{
		title = "Buffers and windows",
		rows = {
			{ "SPC k", "Next buffer" },
			{ "SPC j", "Previous buffer" },
			{ "SPC h", "Close this buffer" },
			{ "SPC H", "Close every other buffer" },
			{ "SPC l", "List open buffers" },
			{ "SPC m k", "Move this tab right" },
			{ "SPC m j", "Move this tab left" },
			{ "SPC v j", "Split horizontally" },
			{ "SPC v k", "Split vertically" },
			{ "SPC v v", "Close the other splits" },
			{ "SPC <", "Make this window taller" },
			{ "SPC >", "Make this window shorter" },
			{ "Ctrl-t", "Open a terminal on the left" },
		},
	},
	{
		title = "Move and fold",
		rows = {
			{ "J", "Page down" },
			{ "K", "Page up" },
			{ "Ctrl-j", "Scroll down" },
			{ "Ctrl-k", "Scroll up" },
			{ "f", "Fold or unfold this block" },
			{ "f d", "Delete this fold" },
		},
	},
	{
		title = "Code (when a language server is attached)",
		rows = {
			{ "g d", "Go to definition" },
			{ "g D", "Go to declaration" },
			{ "g i", "Go to implementation" },
			{ "g r", "Find references" },
			{ "K", "Hover docs, when the server provides them" },
		},
	},
	{
		title = "Git",
		rows = {
			{ "SPC g s t", "Status" },
			{ "SPC g a a", "Stage everything" },
			{ "SPC g a p", "Stage this file in hunks" },
			{ "SPC g c", "Commit" },
			{ "SPC g p s", "Push" },
			{ "SPC g p l", "Pull" },
			{ "SPC g p p", "Push the current branch" },
			{ "SPC g p x", "Push and set upstream" },
			{ "SPC g l l", "Pull the current branch" },
			{ "SPC g d", "Open or close the diff view" },
			{ "SPC g b l", "Blame" },
			{ "SPC g s h", "Show the last commit" },
			{ "SPC g s w", "Switch branch (type the name)" },
			{ "SPC g c o", "Checkout (type the name)" },
			{ "SPC g c b", "Create a branch (type the name)" },
			{ "SPC g r v", "Show remotes" },
			{ "SPC g i i", "Init a repository" },
			{ "SPC g g g", "Type any git command" },
		},
	},
	{
		title = "Plugins",
		rows = {
			{ "SPC p i", "Install plugins" },
			{ "SPC p u", "Sync plugins" },
			{ "SPC p c", "Remove unused plugins" },
		},
	},
}

local M = {}

function M.lines()
	local out = {
		"  Command glossary",
		"  Space is the leader. Type the keys in order. q or Esc closes this panel.",
		"",
	}
	for _, group in ipairs(groups) do
		table.insert(out, "  " .. group.title)
		for _, row in ipairs(group.rows) do
			table.insert(out, string.format("    %-14s  %s", row[1], row[2]))
		end
		table.insert(out, "")
	end
	return out
end

function M.open()
	local buf = vim.api.nvim_create_buf(false, true)
	local lines = M.lines()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "muvim-glossary"

	local width = math.min(78, vim.o.columns - 4)
	local height = math.min(#lines + 1, vim.o.lines - 4)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " Commands ",
		title_pos = "center",
	})
	vim.wo[win].cursorline = true
	vim.wo[win].wrap = false

	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	for _, key in ipairs({ "q", "<Esc>", "<C-c>" }) do
		vim.keymap.set("n", key, close, { buffer = buf, silent = true, nowait = true })
	end
end

return M
