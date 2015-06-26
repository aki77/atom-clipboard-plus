# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ClipboardPlus", ->
  [workspaceElement, editor, editorElement, clipboardPlus] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    waitsForPromise ->
      atom.packages.activatePackage('clipboard-plus').then (pack) ->
        clipboardPlus = pack.mainModule

    waitsForPromise ->
      atom.workspace.open().then (_editor) ->
        editor = _editor
        editorElement = atom.views.getView(editor)

  describe "when the clipboard-plus:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      expect(workspaceElement.querySelector('.clipboard-plus')).not.toExist()
      atom.commands.dispatch editorElement, 'clipboard-plus:toggle'

      expect(workspaceElement.querySelector('.clipboard-plus')).toExist()

      clipboardPlusPanel = atom.workspace.getModalPanels()[0]
      expect(clipboardPlusPanel.isVisible()).toBe true
      atom.commands.dispatch editorElement, 'clipboard-plus:toggle'
      expect(clipboardPlusPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.
      expect(workspaceElement.querySelector('.clipboard-plus')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch editorElement, 'clipboard-plus:toggle'

      # Now we can test for view visibility
      clipboardPlusElement = workspaceElement.querySelector('.clipboard-plus')
      expect(clipboardPlusElement).toBeVisible()
      atom.commands.dispatch editorElement, 'clipboard-plus:toggle'
      expect(clipboardPlusElement).not.toBeVisible()

  describe 'provide', ->
    [clipboardListView, clipboardItems, service] = []

    beforeEach ->
      {clipboardItems} = clipboardPlus
      service = clipboardPlus.provide()

    it 'registerPasteAction', ->
      service.registerPasteAction((_editor, item) ->
        text = "hello #{item.text}"
        _editor.insertText(text)
      )

      expect(editor.getText()).toBe('')
      atom.clipboard.write('world')

      atom.commands.dispatch(editorElement, 'clipboard-plus:toggle')
      clipboardListView = atom.workspace.getModalPanels()[0].getItem()

      clipboardListView.confirmed(clipboardItems.get(0))
      expect(editor.getText()).toBe('hello world')
