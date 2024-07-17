UpdateVsCodeExtList(name, pos, menu) {
    vsCodeExtsDir := EnvGet('USERPROFILE') '\.vscode\extensions'
    extsCsvText := ''
    loop files vsCodeExtsDir '\*', 'D' {
        loop files A_LoopFilePath '\package.json' {
            jsonPackageText := FileRead(A_LoopFilePath)
            getJsonPackageProp(&extName, 'name')
            getJsonPackageProp(&extDisplayName, 'displayName')
            getJsonPackageProp(&extPublisher, 'publisher')
            getJsonPackageProp(&extPublisherDisplayName, 'publisherDisplayName')
            getJsonPackageProp(&extVer, 'version')
            getJsonPackageProp(&extWorkspaceSuffix, 'workspaceSuffix')

            extsCsvText .= '`r`n"'
            try {
                extsCsvText .= extWorkspaceSuffix[1]
            } catch {
                try {
                    extsCsvText .= extDisplayName[1]
                } catch {
                    extsCsvText .= extName[1]
                }
            }

            extsCsvText .= '","' extPublisherDisplayName[1] '","https://marketplace.visualstudio.com/items?itemName='
                    . extPublisher[1] '.' extName[1] '-' extVer[1]
        }
    }

    obsoleteFile := vsCodeExtsDir '\.obsolete'
    try {
        obsoleteFileText := FileRead(obsoleteFile)
        obsoleteFileText := LTrim(obsoleteFileText, '{"')
        obsoleteFileText := RTrim(obsoleteFileText, '":true}')

        obsoleteFileText := StrReplace(obsoleteFileText, '":true,"', '|')
        loop parse obsoleteFileText, '|' {
            extsCsvText := RegExReplace(extsCsvText, 'i).+' A_LoopField '`r`n')
        }
    }

    extsCsvText := RegExReplace(extsCsvText, 'm)-\d+(\.\d+){2}$', '"')
    extsCsvText := Sort(extsCsvText)
    extsCsvText := '"Extension","Publisher","Link"' extsCsvText

    extsCsv := A_AppData '\Code\User\extensions.csv'
    FileRecycle(extsCsv)
    FileAppend(extsCsvText, extsCsv)

    getJsonPackageProp(&extProp, prop) {
        RegExMatch(jsonPackageText, 'm)^' A_Tab '+"' prop '": "(.+)",?$', &extProp)
    }
}
