class UI_Edge {
    static hasFocus() {
        return WinActive('ahk_exe msedge.exe')
    }

    static runVimiumcCommand(command) {
        activationKeys := (() {
            switch command, "Off" {
            case "LinkHints.activate":             return  "{F13}"
            case "LinkHints.activateEdit":         return  "{F14}"
            case "LinkHints.activateHover":        return  "{F15}"
            case "LinkHints.activateCopyLinkUrl":  return  "{F16}"
            case "LinkHints.activateCopyLinkText": return  "{F17}"
            case "reopenTab":                      return  "{F18}"
            case "removeRightTab":                 return  "{F19}"
            case "moveTabLeft":                    return  "{F20}"
            case "moveTabRight":                   return "+{F13}"
            default:
                ; (Can't use A_ThisFunc in the error message because we're in an anonymous
                ; function.)
                throw ValueError("Parameter of " . this.prototype.__Class . ".runVimiumcCommand will not activate a Vimium C command")
            }
        })()
        Send(activationKeys)
    }
}
