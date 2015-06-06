# clipboard-plus package

Keeps your clipboard history.
[![Build Status](https://travis-ci.org/aki77/atom-clipboard-plus.svg)](https://travis-ci.org/aki77/atom-clipboard-plus)

[![Gyazo](http://i.gyazo.com/a7a0ec5441f2b3088647f4cc585548e1.gif)](http://gyazo.com/a7a0ec5441f2b3088647f4cc585548e1)

## Features
* can use the copy/cut command of core.
* support for multiple cursors
* basic support system clipboard
* clipboard-plus and [emacs package](https://atom.io/packages/emacs) can coexist.

## Commands
* `clipboard-plus:toggle`
* `clipboard-plus:clear`


## Keymap

No keymap by default.

edit `~/.atom/keymap.cson`

**general**

```coffeescript
'.platform-darwin atom-text-editor:not([mini])':
  'cmd-shift-v': 'clipboard-plus:toggle'

'.platform-win32 atom-text-editor:not([mini])':
  'ctrl-shift-v': 'clipboard-plus:toggle'

'.platform-linux atom-text-editor:not([mini])':
  'ctrl-shift-v': 'clipboard-plus:toggle'
```

**emacs user**

```coffeescript
'atom-text-editor:not([mini])':
  'alt-y': 'clipboard-plus:toggle'
```

## TODO

- [ ] ui improvements
- [ ] watch system clipboard
- [ ] multiple projects
