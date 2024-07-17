*XButton1 Up:: return

#HotIf GetKeyState('XButton1', 'P')
/**
 * These are needed so that they don't get stuck.
 * Idkw but it has something to do with X1+W.
 * See https://www.autohotkey.com/boards/viewtopic.php?f=82&t=125851
 * which may mean this is a bug:
 */
*MButton:: return
*LButton:: return
*RButton:: return
#HotIf
