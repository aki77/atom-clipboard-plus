{CompositeDisposable, Disposable} = require 'atom'

module.exports =
class ClipboardItems
  limit: 15
  items: []
  destroyed: false

  constructor: (state = {}) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add(@wrapClipboard())
    @subscriptions.add(atom.config.observe('clipboard-plus.limit', (limit) =>
      @limit = limit
    ))
    @items = state.items ? []

  destroy: ->
    return if @destroyed
    @subscriptions?.dispose()
    @subscriptions = null
    @clear()
    @destroyed = true

  wrapClipboard: ->
    {clipboard} = atom
    {write, readWithMetadata} = clipboard

    clipboard.write = (text, metadata = {}) =>
      ignore = metadata.ignore ? false
      delete metadata.ignore
      replace = metadata.replace ? false
      delete metadata.replace

      write.call(clipboard, text, metadata)
      return if ignore
      return if @isIgnoreText(text)

      {text, metadata} = clipboard.readWithMetadata()
      metadata ?= {}
      metadata.time = Date.now()

      @items.pop() if replace
      @push({text, metadata})

    clipboard.readWithMetadata = ->
      result = readWithMetadata.call(clipboard)
      # copy from system clipboard to atom clipboard
      clipboard.write(result.text) unless result.hasOwnProperty('metadata')
      result

    new Disposable ->
      clipboard.write = write
      clipboard.readWithMetadata = readWithMetadata

  push: ({text, metadata}) ->
    @deleteByText(text) if atom.config.get('clipboard-plus.unique')
    @items.push({text, metadata})
    deleteCount = @items.length - @limit
    @items.splice(0, deleteCount) if deleteCount > 0
    # console.log @items if atom.devMode

  size: ->
    @items.length

  delete: (item) ->
    @items.splice(@items.indexOf(item), 1)

  deleteByText: (text) ->
    @items = @items.filter((item) -> item.text isnt text)

  clear: ->
    @items.length = 0

  entries: ->
    @items.slice()

  get: (index) ->
    @items[index]

  serialize: ->
    items: @items.slice()

  syncSystemClipboard: ->
    atom.clipboard.readWithMetadata()
    this

  isIgnoreText: (text) ->
    return true if text.match(/^\s+$/)
    trimmed = text.trim()

    if trimmed.length < atom.config.get('clipboard-plus.minimumTextLength')
      return true
    if trimmed.length > atom.config.get('clipboard-plus.maximumTextLength')
      return true

    false
