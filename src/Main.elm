module Main exposing (main)

import Base64
import Browser exposing (Document)
import Browser.Navigation as Navigation
import Char exposing (toUpper)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import QRCode
import String.Rot13 exposing (rot13, rotBy)
import Svg.String as Svg
import Url



-- TYPES


type alias Document =
    { title : String
    , body : List (Html Msg)
    }


type Msg
    = Noop
    | SubmitInput
    | GetInput String



-- UTILS


leftOf : b -> a -> ( a, b )
leftOf right left =
    ( left, right )


rightOf : a -> b -> ( a, b )
rightOf left right =
    ( left, right )


toDocument : String -> List (Html Msg) -> Document
toDocument title body =
    Document title body



-- MODEL


type alias Solution =
    Maybe String


type alias Submission =
    Maybe String


type State
    = Create Solution
    | Display String
    | Check Solution Submission


type alias Model =
    { url : Url.Url
    , state : State
    }



-- INIT


init : flags -> Url.Url -> Navigation.Key -> ( Model, Cmd msg )
init flags url key =
    case url.fragment of
        Just encodedSolution ->
            { url = url
            , state = Check (decodeText encodedSolution) Nothing
            }
                |> leftOf Cmd.none

        Nothing ->
            { url = url
            , state = Create Nothing
            }
                |> leftOf Cmd.none



-- UPDATE


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        SubmitInput ->
            case model.state of
                Create submission ->
                    case submission of
                        Nothing ->
                            ( model, Cmd.none )

                        Just str ->
                            { model | state = Display str }
                                |> leftOf Cmd.none

                _ ->
                    ( model, Cmd.none )

        GetInput str ->
            case model.state of
                Create solution ->
                    case str of
                        "" ->
                            { model | state = Create Nothing }
                                |> leftOf Cmd.none

                        _ ->
                            let
                                upperStr =
                                    String.map toUpper str
                            in
                            { model | state = Create (Just upperStr) }
                                |> leftOf Cmd.none

                Check solution submission ->
                    case str of
                        "" ->
                            { model | state = Check solution Nothing }
                                |> leftOf Cmd.none

                        _ ->
                            { model
                                | state =
                                    Check
                                        solution
                                        (Just (String.map toUpper str))
                            }
                                |> leftOf Cmd.none

                _ ->
                    ( model, Cmd.none )

        Noop ->
            ( model, Cmd.none )



-- VIEW


pageTitle : String
pageTitle =
    "Lösungswortchecker"


createQRCode : String -> Html msg
createQRCode message =
    QRCode.encode message
        |> Result.map QRCode.toSvg
        |> Result.withDefault
            (Html.text "Error while encoding to QRCode.")


encodeText : String -> String
encodeText =
    Base64.encode << rot13


decodeText : String -> Maybe String
decodeText text =
    Base64.decode text
        |> Result.map rot13
        |> Result.toMaybe


viewCreator : Maybe String -> Document
viewCreator solution =
    let
        input =
            Input.text
                [ centerX
                , centerY
                , Font.size 36
                , Font.family
                    [ Font.typeface "Ubuntu Mono"
                    , Font.typeface "Lucida Sans Typewriter"
                    , Font.monospace
                    ]
                , Border.rounded 5
                ]
                { onChange = GetInput
                , text =
                    Maybe.withDefault
                        ""
                        solution
                , placeholder =
                    Just
                        (Input.placeholder
                            []
                            (text "NEUES LÖSUNGSWORT")
                        )
                , label =
                    Input.labelAbove
                        [ Font.size 28
                        , Font.family
                            [ Font.typeface "Ubuntu"
                            , Font.typeface "Calibri"
                            , Font.sansSerif
                            ]
                        ]
                        (text "Lösungswort:")
                }

        button =
            case solution of
                Just _ ->
                    Input.button
                        [ Font.size 28
                        , Font.family
                            [ Font.typeface "Ubuntu"
                            , Font.typeface "Calibri"
                            , Font.sansSerif
                            ]
                        , Border.rounded 5
                        , centerX
                        , width <| px 400
                        , height <| px 40
                        , Background.color <| rgb255 213 213 213
                        ]
                        { onPress = Just SubmitInput
                        , label =
                            el
                                [ centerX
                                , centerY
                                , Font.variant Font.smallCaps
                                ]
                                (text "Checker erstellen")
                        }

                Nothing ->
                    el
                        [ width <| px 400
                        , height <| px 40
                        ]
                        none
    in
    { title = "Lösungschecker erstellen"
    , body =
        [ Element.layout
            []
            (column
                [ centerX
                , centerY
                , width <| px 800
                , spacing 10
                ]
                [ input, button ]
            )
        ]
    }


viewDisplay : Url.Url -> String -> Document
viewDisplay url solution =
    let
        encodedSolution =
            encodeText solution

        checkerURL =
            Url.toString url
                ++ "#"
                ++ encodedSolution

        qrCode =
            createQRCode checkerURL
                |> html
                |> el
                    [ width shrink
                    , centerX
                    ]

        link =
            newTabLink
                [ Font.size 36
                , Font.color <| rgb255 23 23 231
                , Font.family
                    [ Font.typeface "Ubuntu Mono"
                    , Font.typeface "Lucida Sans Typewriter"
                    , Font.monospace
                    ]
                ]
                { url = checkerURL
                , label = text "Link zum kopieren"
                }

        input =
            Input.text
                [ Font.size 36
                , Font.color <| rgb255 123 123 123
                , Font.family
                    [ Font.typeface "Ubuntu Mono"
                    , Font.typeface "Lucida Sans Typewriter"
                    , Font.monospace
                    ]
                ]
                { onChange = \s -> Noop
                , text = checkerURL
                , placeholder = Nothing
                , label =
                    Input.labelAbove
                        [ Font.size 28
                        , Font.family
                            [ Font.typeface "Ubuntu"
                            , Font.typeface "Calibri"
                            , Font.sansSerif
                            ]
                        ]
                        (text "Copy & Paste:")
                }
    in
    { title = "Lösungschecker URL"
    , body =
        [ Element.layout
            []
            (column
                [ centerX
                , centerY
                , width <| px 800
                , spacing 20

                --, explain Debug.todo
                ]
                [ qrCode, input, link ]
            )
        ]
    }


viewChecker : Maybe String -> Maybe String -> Document
viewChecker solution submission =
    let
        solutionCorrect =
            solution == submission

        content =
            if not solutionCorrect then
                [ Input.text
                    [ centerX
                    , centerY
                    , Input.focusedOnLoad
                    , Font.size 36
                    , Font.family
                        [ Font.typeface "Ubuntu Mono"
                        , Font.typeface "Lucida Sans Typewriter"
                        , Font.monospace
                        ]
                    , Border.rounded 5
                    ]
                    { onChange =
                        \s ->
                            if not solutionCorrect then
                                GetInput s

                            else
                                Noop
                    , text =
                        Maybe.withDefault
                            ""
                            submission
                    , placeholder =
                        Just
                            (Input.placeholder
                                []
                                (text "DEIN LÖSUNGSWORT")
                            )
                    , label =
                        Input.labelAbove
                            [ Font.size 28
                            , Font.family
                                [ Font.typeface "Ubuntu"
                                , Font.typeface "Calibri"
                                , Font.sansSerif
                                ]
                            ]
                            (text "Lösungswort:")
                    }
                ]

            else
                [ el
                    [ centerX
                    , centerY
                    , Font.size 36
                    , Font.family
                        [ Font.typeface "Ubuntu"
                        , Font.typeface "Calibri"
                        , Font.sansSerif
                        ]
                    ]
                    (text "Herzlichen Glückwunsch,")
                , el
                    [ centerX
                    , centerY
                    , Font.size 48
                    , Font.family
                        [ Font.typeface "Ubuntu Mono"
                        , Font.typeface "Lucida Sans Typewriter"
                        , Font.monospace
                        ]
                    ]
                    (text (Maybe.withDefault "" submission))
                , el
                    [ centerX
                    , centerY
                    , Font.size 36
                    , Font.family
                        [ Font.typeface "Ubuntu"
                        , Font.typeface "Calibri"
                        , Font.sansSerif
                        ]
                    ]
                    (text "ist das korrekte Lösungswort.")
                ]

        background =
            if solutionCorrect then
                Background.color (rgb255 23 123 23)

            else
                Background.color (rgba255 255 255 255 1)
    in
    { title = "Lösung überprüfen"
    , body =
        [ Element.layout
            [ background ]
            (column
                [ centerX
                , centerY
                , width <| px 800
                , spacing 10
                ]
                content
            )
        ]
    }


view : Model -> Document
view model =
    case model.state of
        Create solution ->
            viewCreator solution

        Display solution ->
            viewDisplay model.url solution

        Check solution submission ->
            viewChecker solution submission



-- SUBSCRIPTIONS


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none



-- URL CONTROL


urlChange : Url.Url -> Msg
urlChange url =
    Noop


urlRequest : Browser.UrlRequest -> Msg
urlRequest request =
    Noop



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = urlChange
        , onUrlRequest = urlRequest
        }
