# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ClipboardPlus", ->
  [workspaceElement, editor, editorElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    waitsForPromise ->
      atom.packages.activatePackage('clipboard-plus')

    waitsForPromise ->
      atom.workspace.open().then (_editor) ->
        editor = _editor
        editorElement = atom.views.getView(editor)

  describe "when the clipboard-plus:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.clipboard-plus')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
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
