/* CoordMode "Mouse", "Screen"

^LButton::{
global 
MouseGetPos &TrainX, &TrainY
MsgBox "Mouse Position: " TrainX ", " TrainY
}

!t::{
MouseGetPos &NowX, &NowY
MouseClick , TrainX, TrainY
MouseMove NowX, NowY
}

*/