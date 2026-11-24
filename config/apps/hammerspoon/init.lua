local pausedByMic = false

local function onMicEvent(_, event)
  if event ~= "gone" then return end
  if micWatcher:inUse() then
    if hs.spotify.isPlaying() then
      hs.spotify.pause()
      pausedByMic = true
    end
  elseif pausedByMic then
    hs.spotify.play()
    pausedByMic = false
  end
end

local function watchDefaultInput()
  if micWatcher then micWatcher:watcherStop() end
  -- Kept global: a local watcher gets garbage collected and stops firing.
  micWatcher = hs.audiodevice.defaultInputDevice()
  if not micWatcher then return end
  micWatcher:watcherCallback(onMicEvent)
  micWatcher:watcherStart()
end

watchDefaultInput()

hs.audiodevice.watcher.setCallback(function(event)
  if event == "dIn " then watchDefaultInput() end
end)
hs.audiodevice.watcher.start()
