#Include default-settings.ahk
#Include functions.ahk

class C_KeyWait {
    static _states := Map()

    static get(key, options) {
        return this._states[key][options]
    }

    static set(key, options, is_waiting) {
        this._states[key][options] := is_waiting

        if not is_waiting
            return

        KeyWait key, options
        this._states[key][options] := false
    }
}

class C_Hotkey {
    static ctrlTab(hk, should_press_shift) {
        sendFirstAndLast(this_hk) {
            Send '{Ctrl Down}' . tab
            KeyWait HotkeyGetPrefixKey(this_hk)
            Send '{Ctrl Up}'
        }

        tab := (should_press_shift) ? '{Shift Down}{Tab}{Shift Up}' : '{Tab}'

        Hotif this_hk => GetKeyState('Ctrl')
        Hotkey hk, this_hk => Send(tab)

        Hotif
        Hotkey hk, this_hk => sendFirstAndLast(this_hk)
    }

    class Browser {
        static active() {
            return WinActive('ahk_exe msedge.exe') or WinActive('ahk_exe firefox.exe') or WinActive('ahk_exe chrome.exe')
        }

        static gotoSelectedFolder(hk, hotif_ex_functor := '') {
            this.HotifCondition hotif_ex_functor
            Hotkey hk, this_hk => logic()
            logic() {
                selected := GetSelectedElseExit()
                Run 'explore ' . selected
            }
            Hotif
        }

        static HotifCondition(hotif_ex_functor := '') {
            if hotif_ex_functor
                Hotif this_hk => this.active() and hotif_ex_functor()
            else
                Hotif this_hk => this.active()
        }

        static searchSelectedAsUrl(hk, engine := '', hotif_ex_functor := '') {
            searchInTab(in_new) {
                query := GetSelectedElseExit()

                Send '{Ctrl Down}' . (in_new ? 't' : 'l') . '{Ctrl Up}'
                SendInstantRaw (engine) ? this.queryToUrl(query, engine) : query
                SetTimer () => Send('{Enter}'), -10
            }

            this.HotifCondition hotif_ex_functor
            Hotkey hk, this_hk => searchInTab(true)
            Hotkey '+' . hk, this_hk => searchInTab(false)
            Hotif
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
        if this._labels.Has(index) {
            return this._labels[index]
        }
        else {
            this._labels.InsertAt(1, '')
            return
        } 
    }

    static set(function, period := '', priority := '', index := 1) {
        SetTimer function, period, priority

        if not this._labels.Has(index)
            this._labels.InsertAt index, function

        if period > 0 {
            this._labels.RemoveAt index
            this._labels.InsertAt index, function
        }
        else if period = 0 {
            this._labels.RemoveAt index
        }
        else {
            SetTimer () => this._labels.RemoveAt(index), -period
        }
    }
}
