
--------------------------------------------------------------------------------
--                            GeminiBuddy Neovim Plugin
--  Provides a beautiful interface to Gemini's Chat API from within vim.
--
--  Features:
--    1. Prompt-based queries in floating windows.
--    2. Floating result window with markdown formatting.
--    3. Optional "Analyze Code" command to get suggestions or improvements.
--    4. Easy to integrate and extend with your own workflows.
--
--  Usage:
--     1. Set your Gemini API key as an environment variable:
--         export GEMINI_API_KEY="your_api_key"
--     2. In your Neovim config (lua), load this plugin file and call:
--         require("geminibuddy").setup()
--     3. (Optional) Create keymaps or autocmds to trigger the plugin’s functions.
--------------------------------------------------------------------------------

local M = {}

--------------------------------------------------------------------------------
--                                Configuration
--------------------------------------------------------------------------------
local DEFAULT_MODEL       = "gemini-default" -- Replace with an actual Gemini model name if available
local DEFAULT_TEMPERATURE = 0.7
local DEFAULT_MAX_TOKENS  = 1024

-- The plugin’s configuration can be set by the user via M.setup({ ... }).
-- We'll store it in a local table so other functions can reference it.
local config = {
  api_key        = nil,    -- will fall back to env var if nil
  model          = DEFAULT_MODEL,
  temperature    = DEFAULT_TEMPERATURE,
  max_tokens     = DEFAULT_MAX_TOKENS,
  system_message = "You are an expert assistant.",
}

-- Gemini API endpoint (update to match the Gemini API structure)
local gemini_endpoint = "https://api.gemini.com/v1/chat/completions"

--------------------------------------------------------------------------------
--                              Utility Functions
--------------------------------------------------------------------------------

-- Simple logger for debugging
local function log(msg, level)
  vim.notify("[GeminiBuddy] " .. msg, level or vim.log.levels.INFO)
end

-- Attempts to retrieve the API key from environment if not provided in config.
local function get_api_key()
  if config.api_key and #config.api_key > 0 then
    return config.api_key
  end
  local env_key = os.getenv("GEMINI_API_KEY")
  if not env_key or #env_key == 0 then
    log("No Gemini API key found! Set GEMINI_API_KEY or configure via setup().", vim.log.levels.ERROR)
    return nil
  end
  return env_key
end

--------------------------------------------------------------------------------
--                          Low-Level API Call (curl)
--------------------------------------------------------------------------------
-- This function sends a chat completion request to Gemini.
--   prompt (string): The user’s input to be sent.
-- Returns: The model's reply (string) or nil if there's an error.
--------------------------------------------------------------------------------
local function send_request(prompt)
  local api_key = get_api_key()
  if not api_key then return nil end

  local messages = {
    { role = "system", content = config.system_message },
    { role = "user",   content = prompt },
  }

  local request_body = {
    model       = config.model,
    temperature = config.temperature,
    max_tokens  = config.max_tokens,
    messages    = messages,
  }

  local body_json = vim.json.encode(request_body)
  local headers = {
    "Content-Type: application/json",
    "Authorization: Bearer " .. api_key,
  }

  -- Make the request using curl
  local response = vim.fn.system({
    "curl", "-s", "-X", "POST",
    "-H", headers[1],
    "-H", headers[2],
    "-d", body_json,
    gemini_endpoint,
  })

  if vim.v.shell_error ~= 0 then
    log("Error calling the Gemini API. Shell error code: " .. vim.v.shell_error, vim.log.levels.ERROR)
    return nil
  end

  -- Attempt to parse the JSON
  local success, decoded = pcall(vim.json.decode, response)
  if not success or not decoded or not decoded.choices or not decoded.choices[1] then
    log("Invalid JSON response from Gemini. Raw response: " .. response, vim.log.levels.ERROR)
    return nil
  end

  local reply = decoded.choices[1].message and decoded.choices[1].message.content or nil
  return reply
end

--------------------------------------------------------------------------------
--                               UI Helpers
--------------------------------------------------------------------------------

-- Creates a floating window for user input
function M.open_input_box()
  local input_bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(input_bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(input_bufnr, "filetype", "markdown")

  -- Placeholder
  vim.api.nvim_buf_set_lines(input_bufnr, 0, -1, false, { "> Type your prompt here..." })

  local width = 60
  local height = 1

  local input_win_config = {
    relative = "editor",
    width    = width,
    height   = height,
    row      = math.floor((vim.o.lines - height) / 2),
    col      = math.floor((vim.o.columns - width) / 2),
    style    = "minimal",
    border   = "rounded",
    title    = "Enter Prompt",
  }

  local input_winnr = vim.api.nvim_open_win(input_bufnr, true, input_win_config)

  -- Keymaps: Press <CR> to send the message, <Esc> to close
  vim.api.nvim_buf_set_keymap(input_bufnr, "n", "<CR>",
    "<cmd>lua require('geminibuddy').send_message()<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(input_bufnr, "n", "<Esc>",
    "<cmd>close<CR>", { noremap = true, silent = true })

  -- Clear placeholder text once the user starts typing
  vim.api.nvim_create_autocmd("TextChangedI", {
    buffer = input_bufnr,
    callback = function()
      local first_line = vim.api.nvim_buf_get_lines(input_bufnr, 0, 1, false)[1]
      if first_line == "> Type your prompt here..." then
        vim.api.nvim_buf_set_lines(input_bufnr, 0, 1, false, { "" })
      end
    end,
  })
end

-- Reads all lines in the current buffer and sends them as the prompt
function M.send_message()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local prompt = table.concat(lines, "\n")

  M.open_result_window(prompt)
end

-- Create a floating window for the result
function M.open_result_window(prompt)
  local result_bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(result_bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(result_bufnr, "filetype", "markdown")

  local width = math.min(80, math.floor(vim.o.columns * 0.7))
  local height = math.min(20, vim.o.lines - 5)

  local result_win_config = {
    relative = "editor",
    width    = width,
    height   = height,
    row      = math.floor((vim.o.lines - height) / 2),
    col      = math.floor((vim.o.columns - width) / 2),
    style    = "minimal",
    border   = "rounded",
    title    = "GeminiBuddy Response",
  }

  local result_winnr = vim.api.nvim_open_win(result_bufnr, true, result_win_config)

  -- Initial "Thinking..." text
  vim.api.nvim_buf_set_lines(result_bufnr, 0, -1, false, { "Thinking..." })

  -- Asynchronously send request and populate the result
  vim.schedule(function()
    local reply = send_request(prompt)
    if not reply then
      vim.api.nvim_buf_set_lines(result_bufnr, 0, -1, false, { "Error: no reply from API." })
      return
    end

    local lines = {}
    for line in reply:gmatch("([^\n]+)") do
      table.insert(lines, line)
    end

    vim.api.nvim_buf_set_lines(result_bufnr, 0, -1, false, lines)
  end)
end

--------------------------------------------------------------------------------
--                         Optional Code Analysis Feature
--------------------------------------------------------------------------------
function M.analyze_code()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local code = table.concat(lines, "\n")

  local analysis_prompt = table.concat({
    "Please review the following code and provide suggestions, improvements, or potential bug fixes.",
    "",
    code
  }, "\n")

  -- Re-use our open_result_window to display the feedback
  M.open_result_window(analysis_prompt)
end

--------------------------------------------------------------------------------
--                           Plugin Setup Function
--------------------------------------------------------------------------------
function M.setup(opts)
  opts = opts or {}
  config.api_key     = opts.api_key     or config.api_key
  config.model       = opts.model       or config.model
  config.temperature = opts.temperature or config.temperature
  config.max_tokens  = opts.max_tokens  or config.max_tokens
  config.system_message = opts.system_message or config.system_message

  -- Optionally create user commands here for convenience:
  vim.api.nvim_create_user_command("GeminiPrompt", function()
    M.open_input_box()
  end, {})

  vim.api.nvim_create_user_command("GeminiAnalyzeCode", function()
    M.analyze_code()
  end, {})

  log("GeminiBuddy setup complete!")
end

return M
