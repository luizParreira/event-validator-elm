module Update exposing (Msg(..), init, update)

import Api exposing (postEvent)
import Array
import Array.Extra as Array
import Http
import Model exposing (Event, Model, Property)


defaultProperty : Property
defaultProperty =
    { name = "", kind = "string" }


init : a -> ( Model, Cmd Msg )
init _ =
    ( { nameInput = "", properties = [ defaultProperty ], event = Nothing }, Cmd.none )


type Msg
    = InputNameChanged String
    | FormSubmit
    | AddPropertyButtonClicked
    | PropertyNameChanged Int String
    | PropertyKindChanged Int String
    | EventPost (Result Http.Error ())


updateAtIndex : (a -> a) -> Int -> List a -> List a
updateAtIndex updateFn index list =
    list
        |> Array.fromList
        |> Array.update index updateFn
        |> Array.toList


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputNameChanged name ->
            ( { model | nameInput = name }, Cmd.none )

        FormSubmit ->
            let
                event =
                    Event model.nameInput model.properties
            in
            ( { model
                | nameInput = ""
                , properties = []
                , event = Just event
              }
            , postEvent event EventPost
            )

        AddPropertyButtonClicked ->
            ( { model | properties = defaultProperty :: model.properties }, Cmd.none )

        PropertyNameChanged index name ->
            let
                updatePropertyName property =
                    { property | name = name }

                properties =
                    updateAtIndex updatePropertyName index model.properties
            in
            ( { model | properties = properties }, Cmd.none )

        PropertyKindChanged index kind ->
            let
                updatePropertyKind property =
                    { property | kind = kind }

                properties =
                    updateAtIndex updatePropertyKind index model.properties
            in
            ( { model | properties = properties }, Cmd.none )

        EventPost (Err error) ->
            ( model, Cmd.none )

        EventPost (Ok ()) ->
            ( model, Cmd.none )
