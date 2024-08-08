# 🖱️ MouseToys

Keyboard shortcuts are awesome. But sometimes, you just have one hand on the mouse:

![cueball](https://github.com/user-attachments/assets/ce6a629f-bac2-4a87-80c5-a8bf4e34033b)

What if you could do the most common keyboard shortcuts from just your mouse?

## 💻 How to use

1. Grab a mouse with extra side buttons (see [Buttons guide](#%EF%B8%8F-buttons-guide)).
1. Download [AutoHotkey v2.0](https://www.autohotkey.com/download/ahk-v2.exe) (here are the [docs](https://www.autohotkey.com/docs/v2/)).
1. Download and extract the [ZIP of this repo](https://github.com/zachpoblete/MouseToys/archive/refs/heads/main.zip).
1. Run `MouseToys.ahk` and try out these shortcuts!

## 🚀 Accelerated scroll (Scroll wheel)

| Press this | To do this |
| - | - |
| <kbd>WheelUp</kbd> | 🚀 Accelerated scroll up (Scroll faster to scroll farther) |
| <kbd>WheelDown</kbd> | 🚀 Accelerated scroll down |

## 🪟 Window and general shortcuts (XButton1)

| Press this | To do this |
| - | - |
| <kbd>XButton1</kbd>+<kbd>WheelDown</kbd> | ⬇️ Cycle through windows in recently used order (<kbd>Alt</kbd>+<kbd>Tab</kbd>) |
| <kbd>XButton1</kbd>+<kbd>WheelUp</kbd> | ⬆️ Cycle through windows in reverse used order |
| <kbd>XButton1</kbd>+<kbd>MButton</kbd> | 🚚 Restore window and move it using the mouse |
| <kbd>XButton1</kbd>+<kbd>MButton</kbd>+<kbd>WheelDown</kbd> | ↙️ Minimize window |
| <kbd>XButton1</kbd>+<kbd>MButton</kbd>+<kbd>WheelUp</kbd> | &nbsp;↗&thinsp;&hairsp; Maximize window |
| <kbd>XButton1</kbd>+<kbd>MButton</kbd>+<kbd>RButton</kbd> | ❎ Close window |
| <kbd>XButton1</kbd>+<kbd>MButton</kbd>+<kbd>LButton</kbd> | 📸 Screenshot |
| <kbd>XButton1</kbd>+<kbd>LButton</kbd> | ⌦&hairsp; Send Delete key |
| <kbd>XButton1</kbd>+<kbd>LButton</kbd>+<kbd>RButton</kbd> | &nbsp;⏎&thinsp;&hairsp; Send Enter key |
| <kbd>XButton1</kbd>+<kbd>RButton</kbd> | 📋 Copy to clipboard |
| <kbd>XButton1</kbd>+<kbd>RButton</kbd>+<kbd>LButton</kbd> | 📋 Paste from clipboard |
| <kbd>XButton1</kbd>+<kbd>RButton</kbd>+<kbd>WheelDown</kbd> | ↩️ Undo |
| <kbd>XButton1</kbd>+<kbd>RButton</kbd>+<kbd>WheelUp</kbd> | ↪ Redo |

## 🌐 Tab and page shortcuts (XButton2)

| Press this | To do this |
| - | - |
| <kbd>XButton2</kbd>+<kbd>WheelUp</kbd> | ⬅️ Go to left tab |
| <kbd>XButton2</kbd>+<kbd>WheelDown</kbd> | ➡️ Go to right tab |
| <kbd>XButton2</kbd>+<kbd>RButton</kbd>+<kbd>WheelDown</kbd> | ⬇️ Cycle through tabs in recently used order |
| <kbd>XButton2</kbd>+<kbd>RButton</kbd>+<kbd>WheelUp</kbd> | ⬆️ Cycle through tabs in reverse used order |
| <kbd>XButton2</kbd>+<kbd>RButton</kbd> | ❎ Close tab |
| <kbd>XButton2</kbd>+<kbd>RButton</kbd>+<kbd>LButton</kbd> | ↪ Reopen last closed tab |
| <kbd>XButton2</kbd>+<kbd>LButton</kbd> | ⬅️ Go back one page |
| <kbd>XButton2</kbd>+<kbd>LButton</kbd>+<kbd>RButton</kbd> | ➡️ Go forward one page |
| <kbd>XButton2</kbd>+<kbd>LButton</kbd>+<kbd>MButton</kbd> | 🔄 Refresh page |
| <kbd>XButton2</kbd>+<kbd>LButton</kbd>+<kbd>WheelUp</kbd> | 🔍 Zoom in |
| <kbd>XButton2</kbd>+<kbd>LButton</kbd>+<kbd>WheelDown</kbd> | 🔍 Zoom out |
| <kbd>XButton2</kbd>+<kbd>MButton</kbd> | 🔗 <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Click</kbd> <br> Use to open a link in a new active tab <br> or select multiple tabs |

## 🖱️ Buttons guide

![mouse buttons](https://github.com/user-attachments/assets/74860fd1-2f78-48b3-94dd-f499ada45ed3)

- ❶ is <kbd>LButton</kbd>
- ❷ is <kbd>RButton</kbd>
- Pushing directly down on ❸ is <kbd>MButton</kbd>
- Scrolling ❸ forward is <kbd>WheelUp</kbd>
- Scrolling ❸ backward is <kbd>WheelDown</kbd>
- ❹ is <kbd>XButton1</kbd>
- ❺ is <kbd>XButton2</kbd>

An example of a 3-button combination is <kbd>XButton1</kbd>+<kbd>MButton</kbd>+<kbd>RButton</kbd>. This means to press & hold <kbd>XButton1</kbd>, press & hold <kbd>MButton</kbd>, and press & release <kbd>RButton</kbd>.

## 🚩 Known issues

1. [Some mice don't do 3-button combinations well](https://github.com/zachpoblete/MouseToys/issues/43)
1. [Shortcuts can be triggered twice if you click a certain way \[1 solution\]](https://github.com/zachpoblete/MouseToys/issues/8)
1. [Lag when moving window across monitors](https://github.com/zachpoblete/MouseToys/issues/52)

## 📜 License

[MIT](https://github.com/zachpoblete/MouseToys/blob/main/LICENSE)
