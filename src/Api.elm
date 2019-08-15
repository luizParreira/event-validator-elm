module Api exposing (postEvent)

import Dict
import Http
import Json.Encode as Encode exposing (Value)
import Model exposing (Event)


postEvent : Event -> (Result Http.Error () -> msg) -> Cmd msg
postEvent event buildMsg =
    Http.post
        { url = "http://localhost:4000/api/event_schemas"
        , body = Http.jsonBody (eventEncoder event)
        , expect = Http.expectWhatever buildMsg
        }


eventEncoder : Event -> Value
eventEncoder { name, properties } =
    let
        propertiesTuples =
            List.map (\property -> ( property.name, Encode.string property.kind )) properties
    in
    Encode.object
        [ ( "event_schema"
          , Encode.object
                [ ( "name", Encode.string name )
                , ( "schema", Encode.object propertiesTuples )
                ]
          )
        ]
