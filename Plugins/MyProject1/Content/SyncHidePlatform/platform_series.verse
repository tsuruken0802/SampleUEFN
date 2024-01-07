using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

platform_series := class(creative_device):
    @editable
    Prop : creative_prop  = creative_prop {}

    # Generic floor tile asset
    @editable var GenericFloorTile: creative_prop_asset := DefaultCreativePropAsset

    OnBegin<override>()<suspends>:void=
        Print("Hello, world!")
        Print("2 + 2 = {2 + 2}")