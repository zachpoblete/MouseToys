#Include default-settings.ahk
#Include functions.ahk

/**
 * Allows you to check if another thread is waiting for a key.
 */
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
