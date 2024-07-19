#HotIf not WinThatUsesCtrlYAsRedoIsActive()
$^+z:: Send('^y')
$^y::  Send('^+z')
#HotIf
