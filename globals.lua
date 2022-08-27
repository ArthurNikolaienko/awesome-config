if globals then
    return
end ;

local globals = {};

globals.terminal = "kitty"
globals.browser = "firefox"
globals.editor = os.getenv("EDITOR") or "nano"
globals.editor_cmd = globals.terminal .. " -e " .. globals.editor

return globals
