{-# LANGUAGE OverloadedStrings #-}
module Renderer(drawingsToSvg) where

import Text.Blaze.Svg11 ((!))
import qualified Text.Blaze.Svg11 as S
import qualified Text.Blaze.Svg11.Attributes as A
import Shapes

-- Converts a list of drawings into a single SVG of many shapes.
drawingsToSvg :: Drawing -> S.Svg
drawingsToSvg drawings = S.docTypeSvg ! A.version "1.1" ! A.viewbox "-50 -50 100 100" $ do
    createSvgDrawings drawings

-- Recusively converts each Drawing into an SVG shape.
createSvgDrawings :: Drawing -> S.Svg
createSvgDrawings ((transforms, Circle, style):[]) =
    S.circle ! A.r "1" ! S.customAttribute "vector-effect" "non-scaling-stroke" ! A.fill (getFillColourA style) ! A.strokeWidth (getStrokeWidthA style) ! A.stroke (getStrokeColourA style) ! A.transform (transformsToAttributes transforms)

createSvgDrawings ((transforms, Square, style):[]) =
    S.rect ! A.width "1" ! S.customAttribute "vector-effect" "non-scaling-stroke" ! A.height "1" ! A.fill (getFillColourA style) ! A.strokeWidth (getStrokeWidthA style) ! A.stroke (getStrokeColourA style) ! A.transform (transformsToAttributes transforms)

createSvgDrawings ((transforms, Circle, style):drawings) =
    S.circle ! A.r "1" ! S.customAttribute "vector-effect" "non-scaling-stroke" ! A.fill (getFillColourA style) ! A.strokeWidth (getStrokeWidthA style) ! A.stroke (getStrokeColourA style) ! A.transform (transformsToAttributes transforms)
    >> createSvgDrawings drawings

createSvgDrawings ((transforms, Square, style):drawings) =
    S.rect ! A.width "1" ! S.customAttribute "vector-effect" "non-scaling-stroke" ! A.height "1" ! A.fill (getFillColourA style) ! A.strokeWidth (getStrokeWidthA style) ! A.stroke (getStrokeColourA style) ! A.transform (transformsToAttributes transforms)
    >> createSvgDrawings drawings

getStrokeWidthA :: StyleSheet -> S.AttributeValue
getStrokeWidthA style = S.stringValue (show (getStrokeWidth style))

getStrokeColourA :: StyleSheet -> S.AttributeValue
getStrokeColourA style = S.stringValue ("rgba(" ++ (show r) ++ ", " ++ (show g) ++ ", " ++ (show b) ++ ", 1)")
                           where (r, g, b) = getStrokeColour style

getFillColourA :: StyleSheet -> S.AttributeValue
getFillColourA style = S.stringValue ("rgba(" ++ (show r) ++ ", " ++ (show g) ++ ", " ++ (show b) ++ ", 1)")
                           where (r, g, b) = getFillColour style

transformsToAttributes :: [Transform] -> S.AttributeValue
transformsToAttributes transforms = S.stringValue (createTransformAttributes transforms)

createTransformAttributes :: [Transform] -> String
createTransformAttributes (transform:[]) = transformToSvgString transform
createTransformAttributes (transform:transforms) = (transformToSvgString transform) ++ " " ++ (createTransformAttributes transforms)

transformToSvgString :: Transform -> String
transformToSvgString Identity = ""
transformToSvgString (Translate (Vector x y)) = "translate(" ++ (show x) ++ ", " ++ (show y) ++ ")"
transformToSvgString (Scale (Vector x y)) = "scale(" ++ (show x) ++ ", " ++ (show y) ++ ")"
transformToSvgString (Rotate d) = "rotate(" ++ (show d) ++ ")"
