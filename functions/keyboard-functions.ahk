ChordInput() {
    ih := InputHook('')

    ih.keyOpt('{All}', 'E')
    maskKey := RegExReplace(A_MenuMaskKey, '(vk[[:xdigit:]]{2})(sc[[:xdigit:]]{3})', '{$1}{$2}')
    ih.keyOpt('{LWin}{RWin}{LCtrl}{RCtrl}{LShift}{RShift}{LAlt}{RAlt}' maskKey , '-E')

    ih.start()
    ih.wait()
    return ih.endMods ih.endKey
}
