#Include default-settings.ahk
#Include functions.ahk

class C_KeyWait {
    static _states := Map()

    static get(key, options := '') {
        if not (this._states.has(key) and this._states[key].has(options)) {
            return
        }
        return this._states[key][options]
    }

    static set(key, options := '', isWaiting := true) {
        if this._states.has(key) {
            this._states[key][options] := isWaiting
        } else {
            this._states[key] := Map(options, isWaiting)
        }
        if not isWaiting {
            return
        }
        KeyWait(key, options)
        this._states[key][options] := false
    }
}

class C_Hotkey {
    static ctrlTab(hk, shouldPressShift) {
        tab := shouldPressShift ? '{Shift Down}{Tab}{Shift Up}' : '{Tab}'

        HotIf((thisHotkey) => GetKeyState('Ctrl'))
        Hotkey(hk, (thisHotkey) => Send(tab))

        HotIf()
        Hotkey(hk, (thisHotkey) => sendFirstAndLast(thisHotkey))

        sendFirstAndLast(thisHotkey) {
            Send('{Ctrl Down}' tab)
            hk := HkSplit(thisHotkey)
            KeyWait(hk[1])
            Send('{Ctrl Up}')
        }
    }
}

C_InsertInputRightOfCaret.init()
class C_InsertInputRightOfCaret {
    static init() {
        this.ih := InputHook('I'),
        this.ih.keyOpt('{All}', 'N')
        this.ih.backspaceIsUndo := false,
        this.priorInput := '',
        this.ih.onKeyDown := (ih, vk, sc) => this.do()
    }

    static toggle() {
        if GetKeyState('NumLock', 'T') {
            this.ih.start()
        } else {
            this.ih.stop()
        }
    }

    static do() {
        if this.ih.input = this.priorInput {
            return
        }
    
        newestInput := SubStr(this.ih.input, -1)
        Send('{Raw}' newestInput)
        Send('{Left}')
        
        this.priorInput := this.ih.input
    }
}

class C_Timer {
    static _labels := []

    static get(index := 1) {
        if this._labels.has(index) {
            return this._labels[index]
        } else {
            this._labels.insertAt(1, '')
            return
        } 
    }

    static set(fn, periodMs := 250, priority := 0, index := 1) {
        SetTimer(fn, periodMs, priority)

        if not this._labels.has(index) {
            this._labels.insertAt(index, fn)
        }
        if periodMs > 0 {
            this._labels.removeAt(index)
            this._labels.insertAt(index, fn)
        } else if periodMs = 0 {
            this._labels.removeAt(index)
        } else {
            SetTimer(() => this._labels.removeAt(index), periodMs)
        }
    }
}
