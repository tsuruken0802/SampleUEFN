using { /Fortnite.com/Devices }
using { /Verse.org/Native }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_on_off_platform := class(log_channel){}
    
on_off_platform := class<concrete>(creative_device):
    Logger : log = log{Channel := log_on_off_platform }

    @editable
    ToggleDelay : float = 2.0 # プラットフォームが現れて消える間の待ち時間

    @editable
    Platform : color_changing_tiles_device = color_changing_tiles_device{} 

    OnBegin<override>()<suspends> : void =

        # Platform
        loop: 
            Sleep(ToggleDelay) # 次の式に進む前に Sleep(ToggleDelay) は ToggleDelay 秒待機します。
            Platform.Disable() # プラットフォームが非表示になります
            Sleep(ToggleDelay) # 次の式に進む前に Sleep(ToggleDelay) は ToggleDelay 秒待機します。
            Platform.Enable() # プラットフォームが表示になります.
            