{$$} = require 'atom-space-pen-views'
{match} = require 'fuzzaldrin'
ClipboardListView = require './clipboard-list-view'

module.exports =
class ClipboardListBottomView extends ClipboardListView
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

  addPanel: ->
    atom.workspace.addBottomPanel(item: this, className: 'clipboard-plus')

  truncateText: (text) ->
    maximumLinesNumber = atom.config.get('clipboard-plus.maximumLinesNumber')
    return text if maximumLinesNumber is 0
    return text if text.split("\n").length <= maximumLinesNumber

    newText = text.split("\n").slice(0, maximumLinesNumber).join("\n")
    "#{newText}[...]"
