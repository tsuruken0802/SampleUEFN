using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation }
using { /Fortnite.com/UI }

MakeCountdownTimer<constructor><public>(MaxTime : float, InPlayer : agent) := countdown_timer:
    RemainingTime := MaxTime
    MaybePlayerUI := option{GetPlayerUI[player[InPlayer]]} 

countdown_timer := class:
    <# このブロックは、countdown_timer クラスのインスタンスごとに実行されます。
    ここに到達した際にキャンバスを設定できます。#>
    block:
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors:
                        Minimum := vector2{X := 0.4, Y := 0.3}
                        Maximum := vector2{X := 0.6, Y := 0.3}
                    Alignment := vector2{X := 0.5, Y := 0.5 }
                    Offsets := margin{Top := 0.0, Left := 0.0, Bottom := 0.0, Right := 0.0}
                    SizeToContent := true
                    Widget := RemainingTimeTextBlock 
                canvas_slot:
                    Anchors := anchors:
                        Minimum := vector2{X := 0.4, Y := 0.3}
                        Maximum := vector2{X := 0.6, Y := 0.3}
                    Alignment := vector2{X := 0.0, Y := 1.0}
                    Offsets := margin{Top := 0.0, Right := 0.0}
                    SizeToContent := true
                    Widget := AddedTimeTextBlock

    CountdownEndedEvent<public> : event(float) = event(float){}

    StartCountdown<public>() : void =
        if (PlayerUI := MaybePlayerUI?):
            PlayerUI.AddWidget(Canvas)

            # タイマーの開始時に UI を更新して、画面に RemainingTime の初期値を表示します
            UpdateUI()
            spawn:
                RunCountdown()

    AddRemainingTime<public>(Time : float) : void =
        set RemainingTime += Time
        # 時間が追加された際に UI を即座に更新して、より優れたプレイヤー フィードバックを実現します。
        UpdateUI()

        # シンプルなコールアウトを起動して、追加される時間を表示します。
        spawn:
            AddedTimeCallout(Time)

    MaybePlayerUI<internal> : ?player_ui = false
    var RemainingTime<internal> : float = 0.0
    RemainingTimeTextBlock<private> : text_block = text_block{} 
    AddedTimeTextBlock<private> : text_block = text_block{}
    RemainingTimeText<localizes><private>(CurrentRemainingTime : int) : message = "{CurrentRemainingTime}"
    AddedTimeText<localizes><private>(AddedTime : int) : message = " +{AddedTime}!"
    var Canvas<private> : canvas = canvas{}
    var TotalTime<private> : float = 0.0
    # タイマーの「精度」を表し、ティックの頻度を秒単位で表します。
    TimerTickPeriod<private> : float = 1.0

    RunCountdown<private>()<suspends> : void =
        # TimerTickPeriod を使ってループします。
        # UI も毎回更新されます。
        loop:
            Sleep(TimerTickPeriod)
            set TotalTime += TimerTickPeriod
            set RemainingTime -= TimerTickPeriod
            UpdateUI()

            # タイマーの終了
            if (RemainingTime <= 0.0):
                
                Canvas.RemoveWidget(RemainingTimeTextBlock)

                 if (UI := MaybePlayerUI?):
                     UI.RemoveWidget(Canvas)

                CountdownEndedEvent.Signal(TotalTime)
                break

    AddedTimeCallout<private>(Time : float)<suspends> : void =
        if:
            PlayerUI := MaybePlayerUI?
            IntTime := Int[Time]
        then:
            AddedTimeTextBlock.SetVisibility(widget_visibility.Visible)
            AddedTimeTextBlock.SetText(AddedTimeText(IntTime))
            Sleep(2.0)
            AddedTimeTextBlock.SetVisibility(widget_visibility.Hidden)
    
    UpdateUI<private>() : void =
        if (IntTime := Int[RemainingTime]):
            RemainingTimeTextBlock.SetText(RemainingTimeText(IntTime))