module Model exposing (Event, Model, Property)


type alias Property =
    { name : String, kind : String }


type alias Event =
    { name : String, properties : List Property }


type alias Model =
    { nameInput : String, properties : List Property, event : Maybe Event }
