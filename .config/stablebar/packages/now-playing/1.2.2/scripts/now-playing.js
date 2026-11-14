// Streams the playing or paused track from Music or Spotify to StableBar, one JSON line per change.
// Both apps announce track and play/pause changes, so this wakes on those instead of polling.
// While a track plays it reads the position every second for the progress bar and time,
// and everything else every five seconds to catch volume, shuffle and repeat changes.
ObjC.import('AppKit')

const players = [
  { id: 'com.apple.Music', name: 'Apple Music', notification: 'com.apple.Music.playerInfo' },
  { id: 'com.spotify.client', name: 'Spotify', notification: 'com.spotify.client.PlaybackStateChanged' },
]
const cache = $.NSHomeDirectory().js + '/Library/Caches/stablebar-now-playing'
const files = $.NSFileManager.defaultManager
const stdout = $.NSFileHandle.fileHandleWithStandardOutput
let current = null
let artwork = { key: null, path: '' }
let last = ''

// Reading a property of an app that isn't running would launch it, so check first.
function running(player) {
  return $.NSRunningApplication.runningApplicationsWithBundleIdentifier(player.id).count > 0
}

function read(get, fallback) {
  try {
    const value = get()
    return value === undefined || value === null ? fallback : value
  } catch (error) {
    return fallback
  }
}

function readPlayer(player) {
  if (!running(player)) return null
  const app = Application(player.id)
  const state = read(() => app.playerState(), 'stopped')
  if (state === 'stopped') return null
  const spotify = player.id === 'com.spotify.client'
  const track = app.currentTrack
  const info = {
    player,
    app,
    playing: state !== 'paused',
    title: read(() => track.name(), ''),
    artist: read(() => track.artist(), ''),
    album: read(() => track.album(), ''),
    duration: Number(read(() => track.duration(), 0)) / (spotify ? 1000 : 1),
    position: Number(read(() => app.playerPosition(), 0)),
    volume: read(() => app.soundVolume(), null),
    shuffle: read(() => (spotify ? app.shuffling() : app.shuffleEnabled()), false),
    repeat: spotify ? (read(() => app.repeating(), false) ? 'all' : 'off') : read(() => app.songRepeat(), 'off'),
    favorite: spotify ? null : read(() => track.favorited(), null),
  }
  info.artwork = spotify ? read(() => track.artworkUrl(), '') : musicArtwork(info)
  return info
}

// The first playing player wins; otherwise the first paused one.
function readCurrent() {
  let paused = null
  for (const player of players) {
    const info = readPlayer(player)
    if (info && info.playing) return info
    if (info && !paused) paused = info
  }
  return paused
}

// Music returns artwork as data: write the current track's to a file named after the track,
// so StableBar loads a new image only when the track changes. A streamed track's artwork
// can arrive after the track starts, so try again on the next two full reads.
function musicArtwork(info) {
  const key = hash([info.title, info.artist, info.album].join('\n'))
  if (artwork.key !== key) artwork = { key, path: '', tries: 0 }
  if (artwork.path || artwork.tries >= 3) return artwork.path
  artwork.tries++
  const path = cache + '/' + key
  if (!files.fileExistsAtPath(path)) {
    files.removeItemAtPathError(cache, null)
    files.createDirectoryAtPathWithIntermediateDirectoriesAttributesError(cache, true, $(), null)
    const source = [
      'tell application id "com.apple.Music" to set d to raw data of artwork 1 of current track',
      `set f to open for access (POSIX file "${path.replace(/["\\]/g, '\\$&')}") with write permission`,
      'try',
      '  write d to f',
      'end try',
      'close access f',
    ].join('\n')
    $.NSAppleScript.alloc.initWithSource(source).executeAndReturnError(null)
  }
  const data = $.NSData.dataWithContentsOfFile(path)
  if (!data.isNil() && data.length > 0) artwork.path = path
  else files.removeItemAtPathError(path, null)
  return artwork.path
}

function hash(text) {
  let value = 5381
  for (let index = 0; index < text.length; index++) value = (value * 33 + text.charCodeAt(index)) >>> 0
  return value.toString(16)
}

function appIcon(player) {
  if (player.icon === undefined) {
    const bundle = $.NSBundle.bundleWithURL($.NSWorkspace.sharedWorkspace.URLForApplicationWithBundleIdentifier(player.id))
    const file = ObjC.unwrap(bundle.objectForInfoDictionaryKey('CFBundleIconFile')) || 'AppIcon'
    player.icon = bundle.resourcePath.js + '/' + file.replace(/\.icns$/, '') + '.icns'
  }
  return player.icon
}

function clock(seconds) {
  const whole = Math.floor(seconds)
  const pad = (number) => String(number).padStart(2, '0')
  if (whole >= 3600) return `${Math.floor(whole / 3600)}:${pad(Math.floor((whole % 3600) / 60))}:${pad(whole % 60)}`
  return `${Math.floor(whole / 60)}:${pad(whole % 60)}`
}

function output(info) {
  if (!info) return { text: '', hidden: true }
  const icon = appIcon(info.player)
  const timed = info.duration > 0
  const position = Math.min(Math.max(info.position, 0), info.duration)
  const repeating = info.repeat !== 'off'
  const result = {
    text: info.title,
    icon: info.playing ? 'music.note' : 'pause.circle',
    fields: {
      title: info.title,
      artist: info.artist,
      album: info.album,
      line: info.artist ? `${info.title} — ${info.artist}` : info.title,
      control: info.playing ? 'pause.fill' : 'play.fill',
      playing: info.playing ? '1' : '',
      source: info.player.name,
      app: info.player.id,
      appIcon: icon,
      artwork: info.artwork || icon,
      elapsed: timed ? clock(position) : '',
      duration: timed ? clock(info.duration) : '',
      shuffleOn: info.shuffle ? '1' : '',
      shuffleOff: info.shuffle ? '' : '1',
      repeatOn: repeating ? '1' : '',
      repeatOff: repeating ? '' : '1',
      repeatSymbol: info.repeat === 'one' ? 'repeat.1' : 'repeat',
      favorite: info.favorite === null ? '' : info.favorite ? 'star.fill' : 'star',
      volume: info.volume === null ? '' : String(info.volume),
    },
    values: {},
    targets: {},
  }
  if (info.volume !== null) result.values.volume = info.volume / 100
  if (timed) {
    result.values.progress = position / info.duration
    result.targets.progress = info.playing ? Math.min(position + 1, info.duration) / info.duration : position / info.duration
  }
  return result
}

function emit() {
  const line = JSON.stringify(output(current))
  if (line === last) return
  last = line
  stdout.writeData($(line + '\n').dataUsingEncoding($.NSUTF8StringEncoding))
}

function refresh() {
  current = readCurrent()
  emit()
}

// The notification already says whether the player plays or paused: show that at once,
// then read the rest.
function changed(notification) {
  const player = players.find((candidate) => candidate.notification === notification.name.js)
  const state = (ObjC.deepUnwrap(notification.userInfo) || {})['Player State']
  if (current && current.player === player && (state === 'Playing' || state === 'Paused')) {
    current.playing = state === 'Playing'
    emit()
  }
  refresh()
}

ObjC.registerSubclass({
  name: 'NowPlayingObserver',
  methods: { 'changed:': { types: ['void', ['id']], implementation: (notification) => changed(notification) } },
})
const observer = $.NowPlayingObserver.alloc.init
for (const player of players) {
  $.NSDistributedNotificationCenter.defaultCenter.addObserverSelectorNameObject(observer, 'changed:', player.notification, $())
}

refresh()
for (let tick = 1; ; tick++) {
  $.NSRunLoop.currentRunLoop.runUntilDate($.NSDate.dateWithTimeIntervalSinceNow(current && current.playing ? 1 : 5))
  if (current && current.playing && tick % 5 !== 0 && running(current.player)) {
    current.position = Number(read(() => current.app.playerPosition(), current.position))
    emit()
  } else {
    refresh()
  }
}
