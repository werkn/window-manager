;@author Ryan Radford / werkncode.io / github.com/werkn
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;Attempts to emulate some i3m functionality on Windows
;leverage the window management system from AHK
;this lets us skip the headache of writing our own
;
; **Important**:  I developed this tool pretty much for my own use, so I
; assume a dual monitor where the primary and secondary monitor share
; matching resolutions (ie: 2x monitor @ 1920x1080, etc...)
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;grab command line args
arg := a_args[1]

;shrink/grow the active windows by 20% each time, maintains same center point
ResizeActiveWindow(Percent = 0.8)
{
    WinGetPos,X,Y,W,H,A
    Width := (W*Percent)
    dX := ((W-Width))/2
    X := (X+dX)

    Height := (H*Percent)
    dY := ((H-Height))/2
    Y := (Y+dY)

    WinMove,A,,%X%,%Y%,%Width%,%Height%
}

FillTopActiveWindow(MonitorMode = 0)
{
   WinGetPos,X,Y,W,H,A
   if (MonitorMode = 0)
   {
      X := 0
   }
   else
   {
      X := A_ScreenWidth
   }
   Y := 0
   W := A_ScreenWidth
   H := A_ScreenHeight / 2
   WinMove,A,,%X%,%Y%,%W%,%H%
}

FillBottomActiveWindow(MonitorMode = 0)
{
   WinGetPos,X,Y,W,H,A
   if (MonitorMode = 0)
   {
      X := 0
   }
   else
   {
      X := A_ScreenWidth
   }
   Y := A_ScreenHeight / 2
   W := A_ScreenWidth
   H := A_ScreenHeight / 2
   WinMove,A,,%X%,%Y%,%W%,%H%
}

FillRightActiveWindow(MonitorMode = 0)
{
   WinGetPos,X,Y,W,H,A
   if (MonitorMode = 0)
   {
      X := A_ScreenWidth / 2
   }
   else
   {
      X := A_ScreenWidth + (A_ScreenWidth / 2)
   }
   Y := 0
   W := A_ScreenWidth / 2
   H := A_ScreenHeight
   WinMove,A,,%X%,%Y%,%W%,%H%
}

FillLeftActiveWindow(MonitorMode = 0)
{
   WinGetPos,X,Y,W,H,A
   if (MonitorMode = 0)
   {
      X := 0
   }
   else
   {
      X := A_ScreenWidth
   }
   Y := 0
   W := A_ScreenWidth / 2
   H := A_ScreenHeight
   WinMove,A,,%X%,%Y%,%W%,%H%
}

;centers the active window (does not scale or shrink)
CenterActiveWindow(MonitorMode = 0)
{
   WinGetPos,X,Y,W,H,A
   if (MonitorMode = 0)
   {
      xCenter := A_ScreenWidth / 2
   }
   else
   {
      xCenter := (A_ScreenWidth + A_ScreenWidth / 2)
   }

   yCenter := A_ScreenHeight / 2
   X := xCenter - (W/2)
   Y := yCenter - (H/2)
   WinMove,A,,%X%,%Y%,%W%,%H%
}

;centers and fills to 90% the available space
CenterFillActiveWindow(MonitorMode = 0)
{
   WinGetPos,X,Y,W,H,A

   W := A_ScreenWidth * 0.9
   H := A_ScreenHeight * 0.9

   if (MonitorMode = 0)
   {
      X := A_ScreenWidth * 0.05
      Y := A_ScreenHeight * 0.05
   }
   else
   {
      X := A_ScreenWidth + (A_ScreenWidth * 0.05)
      Y := A_ScreenHeight * 0.05
   }

   WinMove,A,,%X%,%Y%,%W%,%H%
}

; ------------------
; |       |        |
; |  #1   |   #2   |
; |       |        |
; |----------------|
; |       |        |
; |  #4   |   #3   |
; |       |        |
; ------------------
SnapActiveWindowToQuad(Quadrant = 1)
{
   WinGetPos,X,Y,W,H,A
   W := (A_ScreenWidth/2)
   H := (A_ScreenHeight/2)
   monitorTopLeftX := (monitor * A_ScreenWidth)
   monitorTopLeftY := (monitor * A_ScreenHeight)
   if (Quadrant = 1 or Quadrant = 5)
   {
      if (Quadrant = 1)
      {
         X := 0
      }
      else
      {
         X := A_ScreenWidth
      }

      Y := 0
   }
   else if (Quadrant = 2 or Quadrant = 6)
   {
      if (Quadrant = 2)
      {
         X := A_ScreenWidth/2
      }
      else
      {
         X := (A_ScreenWidth + A_ScreenWidth/2)
      }

      Y := 0
   }
   else if (Quadrant = 3 or Quadrant = 7)
   {
      if (Quadrant = 3)
      {
         X := A_ScreenWidth/2
      }
      else
      {
         X := (A_ScreenWidth + A_ScreenWidth/2)
      }

      Y := A_ScreenHeight/2
   }
   else if (Quadrant = 4 or Quadrant = 8)
   {
      if (Quadrant = 4)
      {
         X := 0
      }
      else
      {
         X := A_ScreenWidth
      }

      Y := A_ScreenHeight/2
   }
   WinMove,A,,%X%,%Y%,%W%,%H%
}

HexToDec(HexVal)
{
   Old_A_FormatInteger := A_FormatInteger
   SetFormat IntegerFast, D
   DecVal := HexVal + 0
   SetFormat IntegerFast, %Old_A_FormatInteger%
   Return DecVal
}

GetUnderCursorInfo(ByRef CursorX, ByRef CursorY)
{
   CoordMode Mouse, Screen
   CoordMode Pixel, Screen
   MouseGetPos, CursorX, CursorY, Window, Control
   WinGetTitle Title, ahk_id %Window%
   WinGetClass Class, ahk_id %Window%
   WinGetPos WindowX, WindowY, Width, Height, ahk_id %Window%
   WinGet PName, ProcessName, ahk_id %Window%
   WinGet PID, PID, ahk_id %Window%
   PixelGetColor BGR_Color, CursorX, CursorY
   WindowUnderCursorInfo := "ahk_id " Window "`n"
      . "ahk_class " Class "`n"
      . "title: " Title "`n"
      . "control: " Control "`n"
      . "PID: " PID "`n"
      . "process name: " PName "`n"
      . "top left (" WindowX ", " WindowY ")`n"
      . "(width x height) (" Width " x " Height ")`n"
      . "cursor's window position (" CursorX-WindowX ", " CursorY-WindowY ")`n"
      . "cursor's screen position (" CursorX ", " CursorY ")`n"
      . "BGR color: " BGR_Color " (" HexToDec("0x" SubStr(BGR_Color, 3, 2)) ", "
      . HexToDec("0x" SubStr(BGR_Color, 5, 2)) ", "
      . HexToDec("0x" SubStr(BGR_Color, 7, 2)) ")`n"
   Return WindowUnderCursorInfo
}

DisplayWindowInfoTooltip()
{
   WindowUnderCursorInfo := GetUnderCursorInfo(CursorX, CursorY)
   CoordMode ToolTip, Screen
   ; place tooltip in quadrant opposite of cursor
   if ( CursorX < (A_ScreenWidth // 2) )
   {
      TTXOffset = 150
   }
   else
   {
      TTXOffset = -150
   }

   if ( CursorY < (A_ScreenHeight // 2) )
   {
      TTYOffset = 150
   }
   else
   {
      TTYOffset = -150
   }

   ToolTip %WindowUnderCursorInfo%
      , ( (A_ScreenWidth // 2) + TTXOffset )
      , ( (A_ScreenHeight // 2) + TTYOffset )
}

;set monitor mode, assuming 1920x1080 dual monitors, Mode = 0 <--- main display, Mode = 1 secondary display to right
MonitorMode(Mode = 0)
{
   global monitorMode := Mode
}

; big messy arguments checking
if (arg = "--center")
{
   CenterActiveWindow()
}
else if (arg = "--set-top-left")
{
   SnapActiveWindowToQuad(1)
}
else if (arg = "--set-top-right")
{
   SnapActiveWindowToQuad(2)
}
else if (arg = "--set-bottom-left")
{
   SnapActiveWindowToQuad(3)
}
else if (arg = "--set-bottom-right")
{
   SnapActiveWindowToQuad(4)
}
else if (arg = "--shrink")
{
   ResizeActiveWindow(0.8)
}
else if (arg = "--grow")
{
   ResizeActiveWindow(1.2)
}
else if (arg = "--msg")
{
	MsgBox 0,window-manager,%2%
}
else if (arg = "--get-info")
{
   ;esc::exitapp
}

#^q::DisplayWindowInfoTooltip()

;snap controls
>!1::SnapActiveWindowToQuad(1)
>!2::SnapActiveWindowToQuad(2)
>!3::SnapActiveWindowToQuad(3)
>!4::SnapActiveWindowToQuad(4)
>!5::SnapActiveWindowToQuad(5)
>!6::SnapActiveWindowToQuad(6)
>!7::SnapActiveWindowToQuad(7)
>!8::SnapActiveWindowToQuad(8)

;center, shrink or grow bindings
>![::ResizeActiveWindow(0.8)
>!]::ResizeActiveWindow(1.2)
>!,::CenterActiveWindow(0)
>!.::CenterActiveWindow(1)
>!;::CenterFillActiveWindow(0)
>!'::CenterFillActiveWindow(1)
#Up::FillTopActiveWindow(0)
+#Up::FillTopActiveWindow(1)
#Down::FillBottomActiveWindow(0)
+#Down::FillBottomActiveWindow(1)
#Right::FillRightActiveWindow(0)
+#Right::FillRightActiveWindow(1)
#Left::FillLeftActiveWindow(0)
+#Left::FillLeftActiveWindow(1)

