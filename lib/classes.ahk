#Include default-settings.ahk
#Include functions.ahk

class C_KeyWait {
    static _states := Map()

    static get(key, options) {
        return this._states[key][options]
    }

    static set(key, options, isWaiting) {
        this._states[key][options] := isWaiting

        if not isWaiting
            return

        KeyWait key, options
        this._states[key][options] := false
    }
}

class C_Hotkey {
    static ctrlTab(hk, shouldPressShift) {
        sendFirstAndLast(thisHotkey) {
            Send '{Ctrl Down}' . tab
            KeyWait HotkeyGetPrefixKey(thisHotkey)
            Send '{Ctrl Up}'
        }

        tab := (shouldPressShift) ? '{Shift Down}{Tab}{Shift Up}' : '{Tab}'

        HotIf thisHotkey => GetKeyState('Ctrl')
        Hotkey hk, thisHotkey => Send(tab)

        HotIf
        Hotkey hk, thisHotkey => sendFirstAndLast(thisHotkey)
    }

    class Browser {
        static active() {
            return WinActive('ahk_exe msedge.exe') or WinActive('ahk_exe firefox.exe') or WinActive('ahk_exe chrome.exe')
        }

        static runSelectedAsFolder(hk, hotifExFunctor := '') {
            this.hotIfCondition hotifExFunctor
            Hotkey hk, thisHotkey => logic()
            logic() {
                selected := GetSelectedElseExit()
                Run 'explore ' . selected
            }
            HotIf
        }

        static hotIfCondition(hotifExFunctor := '') {
            if hotifExFunctor
                HotIf thisHotkey => this.active() and hotifExFunctor()
            else
                HotIf thisHotkey => this.active()
        }

        static runSelectedAsUrl(hk, engine := '', hotifExFunctor := '') {
            searchInTab(inNew) {
                query := GetSelectedElseExit()

                Send '{Ctrl Down}' . (inNew ? 't' : 'l') . '{Ctrl Up}'
                SendInstantRaw (engine) ? this.queryToUrl(query, engine) : query
                SetTimer () => Send('{Enter}'), -10
            }

            this.hotIfCondition hotifExFunctor
            Hotkey hk, thisHotkey => searchInTab(true)
            Hotkey '+' . hk, thisHotkey => searchInTab(false)
            HotIf
        }
        
        static queryToUrl(query, engine) {
            query := StrReplace(StrReplace(StrReplace(query, '&', '&26'), '+', '%2B'), A_Space, '+')
            return engine . query  ; URL encoding is used to encode special characters in query strings.
        }
    }
}

class C_Timer {
    static _labels := []

    static get(index := 1) {
        if this._labels.has(index) {
            return this._labels[index]
        }
        else {
            this._labels.insertAt(1, '')
            return
        } 
    }

    static set(fn, period := '', priority := '', index := 1) {
        SetTimer fn, period, priority

        if not this._labels.has(index)
            this._labels.insertAt index, fn

        if period > 0 {
            this._labels.removeAt index
            this._labels.insertAt index, fn
        }
        else if period = 0 {
            this._labels.removeAt index
        }
        else {
            SetTimer () => this._labels.removeAt(index), -period
        }
    }
}
