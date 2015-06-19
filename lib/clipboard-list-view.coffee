{$$, SelectListView} = require 'atom-space-pen-views'
{timeSince} = require './util'

module.exports =
class ClipboardListView extends SelectListView
  initialize: (@clipboardItems) ->
    super
    @addClass('clipboard-plus')
    @registerPasteAction(@defaultPasteAction)

  destroy: ->
    @detach()

  getFilterKey: ->
    'text'

  viewForItem: ({text, metadata}) ->
    time = timeSince(metadata.time) if metadata.time?

    $$ ->
      @li =>
        @div class: 'pull-right', =>
          @span time
        @span class: 'text', text.substr(0, 100).replace("\n", "⏎")

  selectItemView: (view) ->
    super

  cancelled: ->
    @panel?.destroy()
    @panel = null
    @editor = null

  # Insert item in clipboardItems and set item to the head
  confirmed: (item) ->
    @clipboardItems.delete(item)
    atom.clipboard.write(item.text, item.metadata)
    @pasteAction(@editor, item)
    @cancel()

  registerPasteAction: (fn) ->
    @pasteAction = fn

  defaultPasteAction: (editor, item) ->
    editor.pasteText()

  attach: ->
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @focusFilterEditor()

  toggle: ->
    if @panel?
      @cancel()
    else if @editor = atom.workspace.getActiveTextEditor()
      @setItems(@clipboardItems.syncSystemClipboard().entries().reverse())
      @attach()
