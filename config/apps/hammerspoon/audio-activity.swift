import CoreAudio
import Darwin

func fail(_ what: String, _ status: OSStatus) -> Never {
  fputs("audio-activity: \(what) failed with OSStatus \(status)\n", stderr)
  exit(1)
}

func globalAddress(_ selector: AudioObjectPropertySelector) -> AudioObjectPropertyAddress {
  AudioObjectPropertyAddress(mSelector: selector, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMain)
}

func readUInt32(_ object: AudioObjectID, _ selector: AudioObjectPropertySelector) -> UInt32? {
  var address = globalAddress(selector)
  var value: UInt32 = 0
  var size = UInt32(MemoryLayout<UInt32>.size)
  return AudioObjectGetPropertyData(object, &address, 0, nil, &size, &value) == noErr ? value : nil
}

func executablePath(_ pid: pid_t) -> String {
  var buffer = [CChar](repeating: 0, count: 4 * Int(MAXPATHLEN))
  return proc_pidpath(pid, &buffer, UInt32(buffer.count)) > 0 ? String(cString: buffer) : "pid:\(pid)"
}

let system = AudioObjectID(kAudioObjectSystemObject)
var listAddress = globalAddress(kAudioHardwarePropertyProcessObjectList)
var size: UInt32 = 0
var status = AudioObjectGetPropertyDataSize(system, &listAddress, 0, nil, &size)
if status != noErr { fail("reading the process list size", status) }
var processes = [AudioObjectID](repeating: 0, count: Int(size) / MemoryLayout<AudioObjectID>.size)
status = AudioObjectGetPropertyData(system, &listAddress, 0, nil, &size, &processes)
if status != noErr { fail("reading the process list", status) }

// A process can exit between listing and querying it; skipping it is the correct reading.
for process in processes {
  guard let pid = readUInt32(process, kAudioProcessPropertyPID) else { continue }
  let path = executablePath(pid_t(bitPattern: pid))
  if readUInt32(process, kAudioProcessPropertyIsRunningInput) == 1 { print("in \(path)") }
  if readUInt32(process, kAudioProcessPropertyIsRunningOutput) == 1 { print("out \(path)") }
}
