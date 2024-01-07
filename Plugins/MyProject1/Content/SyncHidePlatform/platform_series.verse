using { /Fortnite.com/Devices }
using { /Verse.org/Native }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

log_platform_series := class(log_channel){}

platform_series := class<concrete>(creative_device):
    Logger : log = log{Channel := log_platform_series}

    @editable
    HeadStart : float = 2.45 # プラットフォームが現れ始めてから、プラットフォームが消え始めるまでの待ち時間を秒単位で示します。
 
    @editable
    AppearDelay : float = 0.98 # 次のプラットフォームが現れるまでの待ち時間を秒単位で示します。
 
    @editable
    DisappearDelay : float = 1.11 # 次のプラットフォームが消えるまでの待ち時間を秒単位で示します。
 
    @editable
    Platforms : []creative_prop = array{} # プラットフォームが順番に現れる/消えるようにします。

    OnBegin<override>()<suspends> : void =
        <#
        Verse の構造化並行処理では、並行処理とその実行方法の記述方法が豊富です。
        このケースではコルーチンが 2 つあります。
            - すぐに開始し、配列に格納されている順番どおりにプラットフォームを表示する。
            - 同じプラットフォームを配列に格納されている順番どおりにプラットフォームを非表示にする前に開始を待つ。
        #>

        loop:
            sync:
                ShowAllPlatforms() # このコルーチンはすぐに開始され、ブロック式と同時に実行されます。
                block: # このブロック式は ShowAllPlatforms() と同時に直ちに開始されます。このコードブロック内の式はすべて順次実行されます。
                    Sleep(HeadStart) # HideAllPlatforms() が実行されるまで HeadStart 秒待ちます。
                    HideAllPlatforms() # HeadStart 秒後、このコルーチンが実行されます。

    ShowAllPlatforms()<suspends> : void =
        for (PlatformNumber -> Platform :Platforms):
            Logger.Print("Platform{PlatformNumber} is now shown.") 
            Platform.Show()
            Sleep(AppearDelay)

    HideAllPlatforms()<suspends> : void =
        for (PlatformNumber -> Platform :Platforms):
            Logger.Print("Platform{PlatformNumber} is now hidden.") 
            Platform.Hide()
            Sleep(DisappearDelay)