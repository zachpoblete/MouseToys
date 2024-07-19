; For information on what Vimium C is:
; https://github.com/gdh1995/vimium-c

#HotIf UI_Edge.hasFocus()
^;::     UI_Edge.runVimiumcCommand("LinkHints.activateEdit")

^!r::    UI_Edge.runVimiumcCommand("reopenTab")
^!e::    UI_Edge.runVimiumcCommand("removeRightTab")

^+PgUp:: UI_Edge.runVimiumcCommand("moveTabLeft")
^+PgDn:: UI_Edge.runVimiumcCommand("moveTabRight")
#HotIf
