# clipboard-plus package

Keeps your clipboard history.
[![Build Status](https://travis-ci.org/aki77/atom-clipboard-plus.svg)](https://travis-ci.org/aki77/atom-clipboard-plus)

[![Gyazo](http://i.gyazo.com/48cfc66c8f8b7666efb7334d928f1a9e.gif)](http://gyazo.com/48cfc66c8f8b7666efb7334d928f1a9e)

## Features
* can use the copy/cut command of core.
* support for multiple cursors
* basic support system clipboard
* coexist with [emacs-plus package](https://atom.io/packages/emacs-plus).

## Commands
* `clipboard-plus:toggle`
* `clipboard-plus:clear`

## Keymap

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

**vim user**

Please use [vim-mode-clipboard-plus](https://atom.io/packages/vim-mode-clipboard-plus).

## Settings

* `limit` (default: 50)
* `unique` (default: true)
* `minimumTextLength`: (default: 3)
* `maximumTextLength`: (default: 1000)
* `maximumLinesNumber`: (default: 5)

## Usage

**remove one item from the history**

[![Gyazo](http://i.gyazo.com/17d3a26bfb5b069b71aedb64acab846f.gif)](http://gyazo.com/17d3a26bfb5b069b71aedb64acab846f)

## TODO

- [x] ui improvements
- [x] watch system clipboard
- [ ] Share a history with multiple projects
- [x] remove one item from the history
