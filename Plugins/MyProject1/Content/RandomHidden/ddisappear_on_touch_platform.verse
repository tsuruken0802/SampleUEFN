using { /Fortnite.com/Devices }
using { /Verse.org/Random }
using { /Verse.org/Simulation }

disappear_on_touch_platform := class(creative_device):
    # タッチしてから非表示になるまでの時間
    @editable
    DisappearDelay : float = 1.11

    # 表示するまでの最小の時間 
    @editable
    DelayMin : float = 3.8

    # 表示するまでの最大の時間
    @editable
    DelayMax : float = 4.5

    @editable
    Platform : color_changing_tiles_device = color_changing_tiles_device{}

    OnBegin<override>()<suspends> : void =
        # カラー タイルの ActivatedEvent をサブスクライブしてプレイヤーの接触を検出します。
        Platform.ActivatedEvent.Subscribe(OnPlayerTouch)
   
    OnPlayerTouch(InPlayer : agent) : void =
        # spawn により immediate 関数から <suspends> 関数を呼び出すことができます。
        spawn{ RecyclePlatform() }
   
    RecyclePlatform()<suspends> : void =
        Sleep(DisappearDelay) # DisappearDelay 秒待ってからプラットフォームを非表示にします。
        Platform.Hide() # プラットフォームが非表示になります
        Platform.Reset() # プレイヤーが再度アクティブ化できるようにプラットフォームをリセットする必要があります。そうしなければ、ActivatedEvent は初回にしかディスパッチされません。
        Sleep(GetRandomFloat(DelayMin, DelayMax)) # DelayMin と DelayMax 間の乱秒数待ってからプラットフォームを再表示させます。
        Platform.Show() # プラットフォームが表示されます