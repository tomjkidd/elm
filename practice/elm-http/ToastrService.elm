module ToastrService where

toastMailbox : Signal.Mailbox ToastrAction
toastMailbox =
    Signal.mailbox (Success "")

type ToastrAction = Error String | Success String | Info String

type alias ToastrMessage =
    { msgType : String
    , msg : String
    }

toastrActionToMessage : ToastrAction -> ToastrMessage
toastrActionToMessage action =
    case action of
        Error msg -> { msgType = "error", msg = msg }
        Success msg -> { msgType = "success", msg = msg }
        Info msg -> { msgType = "info", msg = msg }

messageHandler : Signal ToastrMessage
messageHandler =
    Signal.map
        toastrActionToMessage
        toastMailbox.signal
