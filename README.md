# Contents

- [Features](#features)
    - [Mouse shortcuts](#%EF%B8%8F-mouse-shortcuts-mouseahk)
    - [Zoom (videoconferencing app) shortcuts](#-zoom-videoconferencing-app-shortcuts)
    - [Keyboard shortcuts](#%EF%B8%8F-keyboard-shortcuts-keyboardahk)
- [What's WheelUp, XButton1, etc.?](#whats-wheelup-xbutton1-etc)
- [What do you mean by clicking or holding a key combo like MButton+RButton?](#what-do-you-mean-by-clicking-or-holding-a-key-combo-like-mbuttonrbutton)
- [Issues](#issues)
- [Notes](#notes)
- [License](#license)

# Features

## 🖱️ Mouse shortcuts <font size ="2">_(mouse.ahk)_</font>

### 🚀 Accelerated Scroll <font size ="2">_(accelerated_scroll.ahk)_</font>

Scroll faster (using <kbd>WheelUp</kbd> and <kbd>WheelDown</kbd>) to scroll farther.

### 🚚 Move window with mouse <font size ="2">_(MouseWinMove)_</font>

Click a window with <kbd>MButton</kbd>+<kbd>RButton</kbd> (automatically restoring the window if maximized) and move the cursor to move the window.

### ↗️↙️ Maximize or minimize/restore window with mouse

Click a window with <kbd>MButton</kbd>+<kbd>WheelUp</kbd> to maximize the window. <font size ="2">_(MouseWinMaximize)_</font>

Click a window with <kbd>MButton</kbd>+<kbd>WheelDown</kbd> to minimize/restore the window to the cursor. <font size ="2">_(MouseWinMinimizeOrRestore)_</font>

### ❌ Close window with mouse <font size ="2">_(MouseWinClose)_</font>

Hold <kbd>XButton2</kbd>+<kbd>MButton</kbd> and release <kbd>MButton</kbd> on a selected window to close it.

### 🔀 Switch to recently used windows (Alt-Tab) with mouse

Click <kbd>RButton</kbd>+<kbd>WheelDown</kbd> to move to older windows, and release <kbd>RButton</kbd> to open the selected window. <font size ="2">_(RButton & WheelDown)_</font>

Click <kbd>RButton</kbd>+<kbd>WheelUp</kbd> to move to newer windows, and release <kbd>RButton</kbd> to open the selected window. <font size ="2">_(RButton & WheelUp)_</font>

While in the Alt-Tab Menu from using the mouse:
- Alternatively, move the cursor to a window and click <kbd>RButton</kbd>+<kbd>LButton</kbd> to open the window. <font size ="2">_(RButton & LButton Up)_</font>
- Move the cursor to a window and click <kbd>RButton</kbd>+<kbd>MButton</kbd> to close the window. <font size ="2">_(RButton & MButton Up)_</font>

### 🔀 Switch to recently used tabs with mouse <font size ="2">_(C_Hotkey.ctrlTab)_</font>

Click a window with <kbd>XButton1</kbd>+<kbd>WheelDown</kbd> to switch to older tabs.

Click a window with <kbd>XButton1</kbd>+<kbd>WheelUp</kbd> to switch to newer tabs.

### ⬅️➡️ Go one tab left or right with mouse <font size ="2">_(X2W)_</font>

Click a window with <kbd>XButton2</kbd>+<kbd>WheelUp</kbd> to go one tab left (one tab up if the tabs were vertically arranged).

Click a window with <kbd>XButton2</kbd>+<kbd>WheelDown</kbd> to go one tab right (one tab down if the tabs were vertically arranged).

### ⬅️➡️ Go back or forward a page with mouse <font size ="2">_(X1LR)_</font>

Hold <kbd>XButton1</kbd>+<kbd>LButton</kbd> and release <kbd>LButton</kbd> on a selected window to go back a page (sends <kbd>Browser_Back</kbd>).

Hold <kbd>XButton1</kbd>+<kbd>RButton</kbd> and release <kbd>RButton</kbd> on a selected window to go forward a page (sends <kbd>Browser_Forward</kbd>).

### 🔄 Reload page with mouse <font size ="2">_(MouseWinReload)_</font>

Hold <kbd>XButton1</kbd>+<kbd>MButton</kbd> and release <kbd>MButton</kbd> on a selected window to reload the page (sends <kbd>F5</kbd>).

### ❌ Close tab with mouse <font size ="2">_(XButton2 & RButton Up)_</font>

Hold <kbd>XButton2</kbd>+<kbd>RButton</kbd> and release <kbd>RButton</kbd> on a selected window to close the current tab.

### ↩️ Undo close tab with mouse <font size ="2">_(XButton2 & LButton Up)_</font>

Hold <kbd>XButton2</kbd>+<kbd>LButton</kbd> and release <kbd>LButton</kbd> on a selected window to reopen the last closed tab.

### ❌ Delete with mouse <font size ="2">_(RButton & LButton Up)_</font>

Click a window with <kbd>RButton</kbd>+<kbd>LButton</kbd> to send <kbd>Delete</kbd>.

## 🎦 Zoom (videoconferencing app) shortcuts

### 🙂 Open reactions <font size ="2">_(Zoom_OpenReactions)_</font>

In a Zoom Meeting, press <kbd>Alt</kbd>+<kbd>E</kbd> to open the reactions.

### 👍 Give a thumbs-up react <font size ="2">_(Zoom_ThumbsUpReact)_</font>

In a Zoom Meeting, press <kbd>Alt</kbd>+<kbd>=</kbd> to give a thumbs-up react.

## ⌨️ Keyboard shortcuts <font size ="2">_(keyboard.ahk)_</font>

### 🕹️ One button remote <font size ="2">_(OneBtnRemote)_</font>

Press <kbd>Pause</kbd>
- ⏯️ once to play/pause the current media that is paused/playing.
- ⏭️ twice to play the next media.
- ⏮️ thrice to play the previous media.

### 📂 Reveal process of active window in File Explorer <font size ="2">_(WinOpenProcessDir)_</font>

While <kbd>NumLock</kbd> is on, press <kbd>D</kbd> to open the process of the active window in File Explorer.

### 📂 Open selection as folder in File Explorer <font size ="2">_(RunSelectedAsDir)_</font>
While <kbd>NumLock</kbd> is on, select some text, and press <kbd>Shift</kbd>+<kbd>D</kbd> to open the selection as a folder in File Explorer.

For example, selecting `%USERPROFILE%\Documents` and pressing <kbd>Shift</kbd>+<kbd>D</kbd> while <kbd>NumLock</kbd> is on will open your Documents folder.

### 🔄 Restart window <font size ="2">_(ProcessRestart)_</font>

Press <kbd>Win</kbd>+<kbd>F5</kbd> to close the process of the active window and open it again.

If there are multiple instances of the process, you will be asked if you want to restart the current instance and close all other instances.

### 🪟 Operate on active window group <font size ="2">_(OperateOnActivateWindowGroup)_</font>

First, create a window group using [GroupAdd](https://www.autohotkey.com/docs/v2/lib/GroupAdd.htm).

In _any_ window that is part of a group:

- Press <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Tab</kbd> to activate the next window in the group (uses [GroupActivate](https://www.autohotkey.com/docs/v2/lib/GroupActivate.htm)).
- Press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>Tab</kbd> to close the active window and activate the next window in the series (uses [GroupClose](https://www.autohotkey.com/docs/v2/lib/GroupClose.htm)).

### ➡️ Insert any key right of caret

Press <kbd>CapsLock</kbd>+<kbd>Any Key</kbd> to insert <kbd>Any Key</kbd> in front of the text cursor indicator or caret (|).

Because, normally, pressing <kbd>Any Key</kbd> would insert it behind the caret.

# What's WheelUp, XButton1, etc.?

![mouse buttons](https://user-images.githubusercontent.com/92368853/218107501-85e6c04b-cbd5-4de3-9c81-cd3450da1ae7.png)

- ❶ is <kbd>LButton</kbd>.

- ❷ is <kbd>RButton</kbd>.

- Pushing directly down on ❸ is <kbd>MButton</kbd>. Scrolling ❸ forward is <kbd>WheelUp</kbd>. Scrolling ❸ backward is <kbd>WheelDown</kbd>.

- ❹ is <kbd>XButton1</kbd> (on my mouse).

- ❺ is <kbd>XButton2</kbd> (on my mouse).

# What do you mean by clicking or holding a key combo like MButton+RButton?

Whenever I say something like, "Click <kbd>MButton</kbd>+<kbd>RButton</kbd>", what I mean is press and hold <kbd>MButton</kbd>, then while <kbd>MButton</kbd> is down, press and release <kbd>RButton</kbd>.

It's like saying, "Press <kbd>Ctrl</kbd>+<kbd>A</kbd>", where <kbd>MButton</kbd> is <kbd>Ctrl</kbd> and <kbd>RButton</kbd> is <kbd>A</kbd>.

Whenever I say something like, "Hold <kbd>XButton2</kbd>+<kbd>MButton</kbd>", what I mean is press and hold <kbd>XButton2</kbd>, then press and hold <kbd>MButton</kbd>.

# Issues

Sometimes, calling Zoom_ThumbsUpReact throws an error when a Zoom Meeting was just launched, and I don't know why.

# Notes

I've only listed the coolest and most original features applicable to most people, but there's a lot more if you check out my individual script files!

# License

[MIT](https://choosealicense.com/licenses/mit/)
