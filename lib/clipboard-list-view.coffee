{SelectListView} = require 'atom-space-pen-views'

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
    @panel ?= @addPanel()
    @focusFilterEditor()

  addPanel: ->
    throw new Error("Subclass must implement a addPanel() method")

  toggle: ->
    if @panel?
      @cancel()
    else if @editor = atom.workspace.getActiveTextEditor()
      @setItems(@clipboardItems.syncSystemClipboard().entries().reverse())
      @attach()
