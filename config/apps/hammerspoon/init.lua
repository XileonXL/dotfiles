local helper = os.getenv("HOME") .. "/.hammerspoon/bin/audio-activity"
-- Siri keeps the microphone and an output stream open permanently.
local ignoredProcesses = { "/corespeechd" }

local mutedDevice = nil

local function isIgnored(path)
  for _, ignored in ipairs(ignoredProcesses) do
    if path:find(ignored, 1, true) then return true end
  end
  return false
end

-- Helper processes of one app (Electron, Chromium) share the .app bundle prefix.
local function appRoot(path)
  return path:match("^(.-%.app)/") or path
end

-- An app that records and plays audio at the same time is a call (Slack, Meet in a browser).
local function shouldMute(output)
  local inputs, outputs = {}, {}
  for kind, path in output:gmatch("(%a+) ([^\n]+)") do
    if not isIgnored(path) then
      if kind == "in" then inputs[appRoot(path)] = true else outputs[appRoot(path)] = true end
    end
  end
  if next(inputs) == nil then return false end
  for app in pairs(inputs) do
    if outputs[app] then return false end
  end
  return true
end

local function mute()
  local device = hs.audiodevice.defaultOutputDevice()
  if not device or device:muted() then return end
  if device:setMuted(true) then
    mutedDevice = device
  else
    print("audio-activity: could not mute " .. device:name())
  end
end

local function unmute()
  if not mutedDevice:setMuted(false) then
    print("audio-activity: could not unmute " .. mutedDevice:name())
  end
  mutedDevice = nil
end

-- Kept global: locals get garbage collected and the timer stops firing.
audioActivityTask = nil
audioActivityTimer = hs.timer.doEvery(1, function()
  if audioActivityTask and audioActivityTask:isRunning() then return end
  audioActivityTask = hs.task.new(helper, function(exitCode, stdOut, stdErr)
    if exitCode ~= 0 then
      print("audio-activity exited with " .. exitCode .. ": " .. stdErr)
      return
    end
    local wanted = shouldMute(stdOut)
    if wanted and not mutedDevice then
      mute()
    elseif not wanted and mutedDevice then
      unmute()
    end
  end)
  audioActivityTask:start()
end)

hs.shutdownCallback = function()
  if mutedDevice then unmute() end
end
