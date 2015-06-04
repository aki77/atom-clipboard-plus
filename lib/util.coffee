timeSince = (time) ->
  seconds = Math.floor((Date.now() - time) / 1000)

  interval = Math.floor(seconds / (3600 * 24))
  return interval + ' days ago'  if interval >= 1

  interval = Math.floor(seconds / 3600)
  return interval + ' hours ago'  if interval >= 1

  interval = Math.floor(seconds / 60)
  return interval + ' minutes ago'  if interval >= 1

  return Math.floor(seconds) + ' seconds ago' if 10 <= seconds
  return 'now'

module.exports = {timeSince}
