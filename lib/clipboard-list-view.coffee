{match} = require 'fuzzaldrin'
ActionSelectListView = require '@aki77/atom-select-action'

module.exports =
class ClipboardListView extends ActionSelectListView
  panelClass: 'clipboard-plus'

  constructor: (@clipboardItems) ->
    super({
      items: @getItems
      filterKey: 'text'
      actions: [
        {
          name: 'Paste'
          callback: @paste
        }
        {
          name: 'Remove'
          callback: @remove
        }
      ]
    })

    @registerPasteAction(@defaultPasteAction)

  getItems: =>
    @clipboardItems.entries().reverse()

  # Insert item in clipboardItems and set item to the head
  paste: (item) =>
    @clipboardItems.delete(item)
    atom.clipboard.write(item.text, item.metadata)
    editor = atom.workspace.getActiveTextEditor()
    @pasteAction(editor, item)

  remove: (item) =>
    @clipboardItems.delete(item)

  registerPasteAction: (fn) ->
    @pasteAction = fn

  defaultPasteAction: (editor, item) ->
    editor.pasteText()

  contentForItem: ({text}, filterQuery) =>
    matches = match(text, filterQuery)
    {truncateText} = this

    ({highlighter}) ->
      @li =>
        @div =>
          @pre -> highlighter(truncateText(text), matches, 0)

  truncateText: (text) ->
    maximumLinesNumber = atom.config.get('clipboard-plus.maximumLinesNumber')
    return text if maximumLinesNumber is 0
    return text if text.split("\n").length <= maximumLinesNumber

    newText = text.split("\n").slice(0, maximumLinesNumber).join("\n")
    "#{newText}[...]"
