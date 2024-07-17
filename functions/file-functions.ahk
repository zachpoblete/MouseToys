GetFileExt(fileName) {
    RegExMatch(fileName, '\.[^.]+$', &fileExt)
    return fileExt
}

OnFileSave(fileName, fn, shouldCall := true) {
    periodMs := shouldCall ? 1000 : 0
    SetTimer(() => funcIfSave(fn), periodMs)

    funcIfSave(fn) {
        fileAttrib := FileGetAttrib(fileName)
        if not InStr(fileAttrib, 'A') {
            return
        }

        FileSetAttrib('-A', fileName)
        fn()
    }
}

StdOut(text, delayMs := '', delimiter := '') {
    if delayMs = '' {
        FileAppend(text, '*')
        return
    }

    loop parse text, delimiter {
        FileAppend(A_LoopField delimiter, '*')
        Sleep(delayMs)
    }
}
