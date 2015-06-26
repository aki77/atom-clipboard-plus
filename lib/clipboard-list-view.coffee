{$$} = require 'atom-space-pen-views'
{match} = require 'fuzzaldrin'
SelectActionView = require './select-list-action-view'

module.exports =
class ClipboardListView extends SelectActionView
  className: 'clipboard-plus'

  initialize: ({@clipboardItems}) ->
    super
    @addClass('clipboard-plus')
    @registerPasteAction(@defaultPasteAction)
    @setActions([
      {
        name: 'Paste'
        callback: @paste
      }
      {
        name: 'Remove'
        callback: @remove
      }
    ])

  getFilterKey: ->
    'text'

  # Insert item in clipboardItems and set item to the head
  paste: (item) =>
    @clipboardItems.delete(item)
    atom.clipboard.write(item.text, item.metadata)
    editor = atom.workspace.getActiveTextEditor()
    @pasteAction(editor, item)
    @cancel()

  remove: (item) =>
    @clipboardItems.delete(item)
    @cancel()

  registerPasteAction: (fn) ->
    @pasteAction = fn

  defaultPasteAction: (editor, item) ->
    editor.pasteText()

  viewForItem: ({text, metadata}) ->
    filterQuery = @getFilterQuery()
    matches = match(text, filterQuery)
    {truncateText} = this

    $$ ->
      # https://github.com/atom/command-palette/blob/master/lib/command-palette-view.coffee#L60
      highlighter = (text, matches, offsetIndex) =>
        lastIndex = 0
        matchedChars = [] # Build up a set of matched chars to be more semantic

        for matchIndex in matches
          matchIndex -= offsetIndex
          continue if matchIndex < 0 # If marking up the basename, omit command matches
          unmatched = text.substring(lastIndex, matchIndex)
          if unmatched
            @span matchedChars.join(''), class: 'character-match' if matchedChars.length
            matchedChars = []
            @text unmatched
          matchedChars.push(text[matchIndex])
          lastIndex = matchIndex + 1

        @span matchedChars.join(''), class: 'character-match' if matchedChars.length

        # Remaining characters are plain text
        @text text.substring(lastIndex)

      @li =>
        @div =>
          @pre -> highlighter(truncateText(text), matches, 0)

  truncateText: (text) ->
    maximumLinesNumber = atom.config.get('clipboard-plus.maximumLinesNumber')
    return text if maximumLinesNumber is 0
    return text if text.split("\n").length <= maximumLinesNumber

    newText = text.split("\n").slice(0, maximumLinesNumber).join("\n")
    "#{newText}[...]"
