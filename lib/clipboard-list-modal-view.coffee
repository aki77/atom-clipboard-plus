{$$} = require 'atom-space-pen-views'
ClipboardListView = require './clipboard-list-view'
{timeSince} = require './util'

module.exports =
class ClipboardListModalView extends ClipboardListView
  viewForItem: ({text, metadata}) ->
    time = timeSince(metadata.time) if metadata.time?

    $$ ->
      @li =>
        @div class: 'pull-right', =>
          @span time
        @span class: 'text', text.substr(0, 100).replace("\n", "⏎")

  addPanel: ->
    atom.workspace.addModalPanel(item: this)
