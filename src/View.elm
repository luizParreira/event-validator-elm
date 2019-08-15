module View exposing (view)

import Browser
import Html exposing (Html, button, div, h3, input, option, select, table, text, th, thead)
import Html.Attributes exposing (class, src, style, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (Event, Model, Property)
import Update exposing (Msg(..))


propertyInputView : Int -> Property -> Html Msg
propertyInputView index { name, kind } =
    div []
        [ input
            [ onInput (PropertyNameChanged index), value name ]
            []
        , select [ onInput (PropertyKindChanged index), value kind ]
            [ option [] [ text "string" ]
            , option [] [ text "number" ]
            ]
        ]


propertyView : Property -> Html Msg
propertyView { name, kind } =
    div []
        [ div [ style "color" "#ff79c6" ] [ text name ]
        , div [ style "color" "#f8f8f2" ] [ text kind ]
        ]


eventView : Event -> Html Msg
eventView { name, properties } =
    div [ style "background-color" "#282a36" ]
        [ h3 [ style "color" "#50fa7b" ] [ text name ]
        , div [] (List.map propertyView properties)
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Event Schema"
    , body =
        [ div [] [ text "Event Name" ]
        , input [ value model.nameInput, onInput InputNameChanged ] []
        , div []
            [ div []
                [ text "Properties" ]
            , button [ onClick AddPropertyButtonClicked ] [ text "Add Property" ]
            , div [] (List.indexedMap propertyInputView model.properties)
            ]
        , button [ onClick FormSubmit ] [ text "Clica em mim" ]
        , case model.event of
            Just event ->
                eventView event

            Nothing ->
                div [] [ text "Nada" ]
        ]
    }
