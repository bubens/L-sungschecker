module String.Rot13 exposing (rot13, rotBy, rotWithCharsetBy)

import Array
import List.Extra as List
import Maybe


rot13 : String -> String
rot13 =
    rotBy 13


rotBy : Int -> String -> String
rotBy =
    rotWithCharsetBy <|
        String.toList "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


rotWithCharsetBy : List Char -> Int -> String -> String
rotWithCharsetBy chars n source =
    let
        len =
            List.length chars
    in
    String.map
        (\char ->
            let
                charIndex =
                    List.elemIndex (Char.toUpper char) chars
            in
            case charIndex of
                Just index ->
                    let
                        rotatedIndex =
                            modBy len (index + n)
                    in
                    List.getAt rotatedIndex chars
                        |> Maybe.map
                            (\c ->
                                if Char.isUpper char then
                                    Char.toUpper c

                                else
                                    Char.toLower c
                            )
                        |> Maybe.withDefault '?'

                Nothing ->
                    char
        )
        source
