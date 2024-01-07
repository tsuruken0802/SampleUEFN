
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
move_platform := class(creative_device):

    @editable
    MyTrigger : trigger_device = trigger_device{}

    @editable
    MyCreativeProp : creative_prop = creative_prop{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        MyTrigger.TriggeredEvent.Subscribe(OnMyEvent)

    OnMyEvent(Agent: ?agent):void=
        spawn:
            MovePlatform()

    MovePlatform()<suspends>:void=
        Print("hello")
        var StartPosition : vector3 = MyCreativeProp.GetTransform().Translation
        var EndPosition : vector3 = vector3{X:=StartPosition.X, Y:=StartPosition.Y, Z:=1000.0}

        loop:
            var CurrentPosition : vector3 = MyCreativeProp.GetTransform().Translation
            if (Distance(CurrentPosition, EndPosition) > 10.0):
                NewPosition: float = CurrentPosition.Z + 10.0
                MyCreativeProp.MoveTo(vector3{X:=CurrentPosition.X, Y:=CurrentPosition.Y, Z:=NewPosition}, MyCreativeProp.GetTransform().Rotation, 0.3)
            else:
                break:

        
        