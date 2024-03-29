﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Menu, Tray, Icon, shell32.dll, 283 ; this changes the tray icon to a little keyboard!
#Include C:\mo-ahk\premiere-functions.ahk
#Include C:\mo-ahk\windows-functions.ahk
#Include C:\mo-ahk\general-functions.ahk

; Keys and corresponding symbols
;------------
;ctrl = ^
;shift = +
;alt = !
;win = #
;------------

;----------------------------------------------;
;                                              ;
;              Adobe Premire Pro               ;
;                                              ;
;----------------------------------------------;
#IfWinActive, ahk_exe Adobe Premiere Pro.exe

;SELECT CLIP AT PLAYHEAD AND RIPPLE DELETE
F1::
Send ^!s ;ctrl alt s -> [select clip at playhead]
sleep 1
Send ^!+d ;ctrl alt shift  d -> [ripple delete]
return

;DELETE SINGLE CLIP AT CURSOR (W/ LINKED AUDIO)
;KNOWN FLAWS
;   - If the clip has a speed ramp and the speed ramp handle is clicked the clip doesn't delete
F2::
prFocus("timeline") ;This will bring focus to the timeline
send, ^+a ;ctrl shift a -> [deselect all]
send, v ;[selection tool]
send, {lbutton}
send, {Delete} ;[clear]
return

;SEARCH EFFECTS PANEL
;F3::
send, ^!+7 ;[focus on effect panel]
sendinput, ^b ;[select find box]
return

;CUT ALL UNLOCKED LAYERS AT CURSOR
;KNOWN FLAWS 
;   - Doesn't select caption tracks smh
F4::
;instant cut at cursor (UPON KEY RELEASE) -- super useful! even respects snapping!
send, c ;[razor tool]
send, {shift down} ;makes the razor tool affect all (unlocked) tracks
keywait, F4 ;waits for the F4 to be released
;tooltip, was released
send, {lbutton} ;left mouse button - makes a CUT
send, {shift up} ;release shift
sleep 10
send, v ;[selection tool]
return

;F5::
;return

;F6::
;return

;F7::
;return

;F8::
;return

;DELETE SINGLE CLIP AT CURSOR (W/O LINKED AUDIO)
F9::
prFocus("timeline") ;This will bring focus to the timeline
send, ^+a ;ctrl shift a -> [deselect all]
send, v ;[selection tool]
send, {alt down}
send, {lbutton}
send, {alt up}
send, {Delete} ;[clear]
return

;F10::
;return

;F11::
;return


;F12::
;return


;----------------------------------------------;
;                                              ;
;                 Windows                      ;
;                                              ;
;----------------------------------------------;

;----------------------------------------------------------------------
;INSTANT APPLICATION SWITCHER KEYS - Start
#IfWinActive
;ctrl numpad1 -> Mapped to mouse
^Numpad1::switchToPremiere()
;ctrl numpad2 -> Mapped to mouse
^Numpad2::switchToFileExplorer()
;ctrl numpad3 -> Mapped to mouse
^Numpad3::switchToChrome()
;ctrl numpad4 -> Mapped to mouse
^Numpad4::switchToAsana()
;ctrl numpad5 -> Mapped to mouse
^Numpad5::switchToSlack()

;INSTANT GOOGLE SEARCH
^+!g::
switchToChrome()
Sleep, 250
;Create new tab
SendInput, ^t
Sleep, 10
return

;OLD CODE - Allows input and pastes input into google search
; InputBox, searchQuery, Google Search, Enter your search., , 250git , 130
; Clipboard := searchQuery
; if (ErrorLevel == 1){
;     ;User pressed cancel
;     return
; }
; Else
; {
;     ;User submitted input
;     switchToChrome()
;     Sleep, 250
;     ;Create new tab
;     SendInput, ^t
;     Sleep, 10
;     SendInput, ^v
;     SendInput, {Enter}
;     return
; }

;INSTANT APPLICATION SWITCHER KEYS - End
;----------------------------------------------------------------------


;----------------------------------------------------------------------
;SET LAPTOP AS DEFAULT PLAYBACK DEVICE - Start
^+F12::
BlockInput, MouseMove ;Block mouse movement
CoordMode, Mouse, Window
MouseGetPos, mousePosX, mousePosY ;Save current mouse position
SendInput #r
Clipboard := "control mmsys.cpl sounds"
WinWaitActive , ahk_class #32770, ,3 ;Wait for Windows Run Panel to be active - Timeout after 2s
if (ErrorLevel == 1){
    tippy("Timed out.", 1)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
SendInput, ^v
SendInput, {Enter}
WinWaitActive , ahk_exe rundll32.exe, ,2 ;Wait for Sound Window to be active - Timeout after 2s
if (ErrorLevel == 1){
    tippy("Timed out.", 1)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
MouseMove, 160, 300, 0 ;Move mouse to headset playback device
SendInput, {LButton} ;Select Monitor playback device
MouseMove, 600, 1100, 0 ;Move mouse to "Set Default" button
SendInput, {LButton} ;Set monitor as the default playback device
MouseMove, 970, 40, 0 ;Move mouse to "Close Window X" button
SendInput, {LButton} ;Select Monitor playback device
MouseMove, mousePosX, mousePosY, 0 ;Move mouse back to saved position
BlockInput, MouseMoveOff ;Enable mouse movement
return

;SET LAPTOP AS DEFAULT PLAYBACK DEVICE - End
;----------------------------------------------------------------------

;----------------------------------------------------------------------
;SET HEADSET AS DEFAULT PLAYBACK DEVICE - Start
^+F11::
BlockInput, MouseMove ;Block mouse movement
CoordMode, Mouse, Window
MouseGetPos, mousePosX, mousePosY ;Save current mouse position
SendInput #r
Clipboard := "control mmsys.cpl sounds"
WinWaitActive , ahk_class #32770, ,2 ;Wait for Windows Run Panel to be active - Timeout after 2s
if (ErrorLevel == 1){
    tippy("Timed out.", 1)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
SendInput, ^v
SendInput, {Enter}
WinWaitActive , ahk_exe rundll32.exe, ,2 ;Wait for Sound Window to be active - Timeout after 2s
if (ErrorLevel == 1){
    tippy("Timed out.", 1)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
MouseMove, 160, 430, 0 ;Move mouse to headset playback device
SendInput, {LButton} ;Select headset playback device
MouseMove, 600, 1100, 0 ;Move mouse to "Set Default" button
SendInput, {LButton} ;Set monitor as the default playback device
MouseMove, 970, 40, 0 ;Move mouse to "Close Window X" button
SendInput, {LButton} ;Select Monitor playback device
MouseMove, mousePosX, mousePosY, 0 ;Move mouse back to saved position
BlockInput, MouseMoveOff ;Enable mouse movement
return

;SET HEADSET AS DEFAULT PLAYBACK DEVICE - End
;----------------------------------------------------------------------

;----------------------------------------------------------------------
;OPEN PROJECT AT CURSOR
^F2::
BlockInput, MouseMove ;Block mouse movement
CoordMode, Mouse, Relative
;Open "Main" project folder
SendInput, {LButton}
SendInput, {LButton}
;Wait for File Explorer Window to be active
WinWaitActive , ahk_class CabinetWClass, ,2
if (ErrorLevel == 1){
    tippy("Timed out.", 1)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
;Move mouse to ensure the projects folder isn't highlighted (This ruins the image search)
MouseMove, 900, 50, 0
;Wait a little longer for File Explorer GUI to load for ImageSearch
Sleep, 200 
;tippy("Correct window is active", 2) ;DEBUGGING
;Search for "Project Files" folder
ImageSearch, OutputVarX, OutputVarY, 300, 360, 1100, 1000, *6 C:\mo-ahk\support-files\laptop-project-files-folder-2.png
if (ErrorLevel == 0)
{
    ;Move mouse to where the project file was found
    MouseMove, OutputVarX+50, OutputVarY+10, 0
    ;tippy("cursor over Project Files Folder", 2) ;DEBUGGING
    ;MsgBox, found image at x: %OutputVarX% and y: %OutputVarY% ;DEBUGGING
}
Else if (ErrorLevel == 1)
{
    tippy("Unable to find Project File Folder image", 2)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
Else
{
    tippy("Problem prevented Project File Folder search", 2)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
;tippy("Cursor over Project Files Folder", 1) ;DEBUGGING
;Open "Project Files" folder
Click, 2
Sleep, 200
;Move mouse to ensure the projects folder isn't highlighted (This ruins the image search)
MouseMove, 900, 50, 0
;Search for Premiere Pro Project
if (findPremiereProFileLaptop() == 0)
{
    ;Open Premiere Pro Project
    Click, 2
}
BlockInput, MouseMoveOff ;Enable mouse movement
return
;----------------------------------------------------------------------


;----------------------------------------------------------------------
;RENAME AND OPEN PREMIERE PROJECT
^+F2::
BlockInput, MouseMove ;Block mouse movement
CoordMode, Mouse, Relative
;Select "Main" project folder
SendInput {LButton}
;Highlight & copy the name of the "Main" project folder
SendInput {F2}
SendInput ^c
MouseGetPos, mousePosX, mousePosY
MouseMove, mousePosX+300, mousePosY, 0
Sleep, 10
;Open "Main" project folder
Click, 2
;Wait for File Explorer Window to be active
WinWaitActive , ahk_class CabinetWClass, ,2
if (ErrorLevel == 1){
    tippy("Timed out.", 1)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
;Move mouse to ensure the projects folder isn't highlighted (This ruins the image search)
MouseMove, 900, 50, 0
;Wait a little longer for File Explorer GUI to load for ImageSearch
Sleep, 700 
;tippy("Correct window is active", 2) ;DEBUGGING
;Search for "Project Files" folder
ImageSearch, OutputVarX, OutputVarY, 300, 360, 1100, 1000, *120 C:\mo-ahk\support-files\laptop-project-files-folder-2.png
if (ErrorLevel == 0)
{
    ;Move mouse to where the project file was found
    MouseMove, OutputVarX+10, OutputVarY+10, 0
    ;tippy("cursor over Project Files Folder", 2) ;DEBUGGING
    ;MsgBox, found image at x: %OutputVarX% and y: %OutputVarY% ;DEBUGGING
}
Else if (ErrorLevel == 1)
{
    tippy("Unable to find Project File Folder image", 2)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
Else
{
    tippy("Problem prevented Project File Folder search", 2)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
;Open the "Projects folder"
Click, 2
;Wait for folder to open
Sleep, 250
;Move mouse to ensure the projects folder isn't highlighted (This ruins the image search)
MouseMove, 900, 50, 0
;Search for Premiere Pro Project
if (findPremiereProFileLaptop() == 0)
{
    ;tippy("cursor over Premiere Pro Project file", 2) ;DEBUGGING
    ;Select, highlight, and rename Premiere Pro project
    SendInput {LButton}
    SendInput {F2}
    Sleep, 10
    SendInput ^v
    SendInput {Enter}
    ;Open Premiere Pro Project
    SendInput {Enter}
    
}
BlockInput, MouseMoveOff ;Enable mouse movement
Return
;----------------------------------------------------------------------

;----------------------------------------------------------------------
;OPEN CHROME AND WORK TABS (TSheets, Caledar, Gmail)
^+F10::
BlockInput, MouseMove ;Block mouse movement
CoordMode, Mouse, Screen
;Run PM Chrome
MouseMove 1250, 2350, 0
SendInput {LButton}

CoordMode, Mouse, Relative
WinWaitActive , ahk_exe chrome.exe, ,2 ;Wait for Chrome Window to be active - Timeout after 2s
if (ErrorLevel == 1){
    tippy("Chrome didn't open.", 1)
    BlockInput, MouseMoveOff ;Enable mouse movement
    return
}
Sleep, 100

;Open Tsheets Bookmark
MouseMove 150, 230, 0
SendInput {LButton}
SendInput ^t
Sleep 50
;tippy("Tsheets opened", 0.5) ;DEBUGGING
;Open Calendar Bookmark
MouseMove 400, 230, 0
SendInput {LButton}
SendInput ^t
Sleep 50
;tippy("Calendar opened", 0.5) ;DEBUGGING
;Open Gmail Bookmark
MouseMove 580, 230, 0
SendInput {LButton}
Sleep 50
;tippy("Gmail opened", 0.5) ;DEBUGGING

;Select TSheets Tab
MouseMove 200, 60, 0
SendInput {LButton} 
;ippy("Tsheets selected", 0.5) ;DEBUGGING

BlockInput, MouseMoveOff ;Enable mouse movement
Return
