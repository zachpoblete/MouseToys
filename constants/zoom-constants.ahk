K_CLASSES['ZOOM'] := Map(
    'HOME',           'ZPPTMainFrmWndClassEx',
    'HIDDEN_TOOLBAR', 'ZPFloatToolbarClass',
    'MEETING',        'ZPContentViewWndClass',
    'MIN_CONTROL',    'ZPActiveSpeakerWndClass',
    'MIN_VID',        'ZPFloatVideoWndClass',
    'TOOLBAR',        'ZPToolBarParentWndClass',
    'REACTION',       'ZPReactionWndClass',
    'VID_PREVIEW',    'VideoPreviewWndClass',
    'WAIT_HOST',      'zWaitHostWndClass'
)

ConvertClassesAbbrevsToFullForm()
ConvertClassesAbbrevsToFullForm() {
for abbrev, fullForm in K_CLASSES['ZOOM'] {
    K_CLASSES['ZOOM'][abbrev] := 'ahk_class ' fullForm
}
}

K_CONTROLS['ZOOM'] := Map(
    'MEETING_CONTROLS', 'ZPControlPanelClass1'
)
