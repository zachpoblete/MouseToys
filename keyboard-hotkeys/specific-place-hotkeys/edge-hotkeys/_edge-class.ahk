class UI_Edge {
    static hasFocus() {
        return WinActive('ahk_exe msedge.exe')
    }

    static closeCurrentTab() {
        Send("^w")
    }

    static switchToAdjacentTab(leftOrRight) {
        activationKeys := ""
        switch leftOrRight, "Off" {
        case "left":  activationKeys := "^{PgUp}"
        case "right": activationKeys := "^{PgDn}"
        default: throw ValueError("Parameter of " A_ThisFunc " should be `"left`" or `"right`".")
        }
        Send(activationKeys)
    }

    static runVimiumcCommand(command) {
        activationKeys := ""
        switch command, "Off" {
        case "LinkHints.activate":             activationKeys :=  "{F13}"
        case "LinkHints.activateEdit":         activationKeys :=  "{F14}"
        case "LinkHints.activateHover":        activationKeys :=  "{F15}"
        case "LinkHints.activateCopyLinkUrl":  activationKeys :=  "{F16}"
        case "LinkHints.activateCopyLinkText": activationKeys :=  "{F17}"
        case "reopenTab":                      activationKeys :=  "{F18}"
        case "removeRightTab":                 activationKeys :=  "{F19}"
        case "moveTabLeft":                    activationKeys :=  "{F20}"
        case "moveTabRight":                   activationKeys := "+{F13}"
        }
        Send(activationKeys)
    }
}
