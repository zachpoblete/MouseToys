#Include default-settings.ahk

G_IsMouseMovingWin := false
G_WillReload := false

class G_ {
    static virtualScreenW => SysGet(78)
    static virtualScreenH => SysGet(79)
}
