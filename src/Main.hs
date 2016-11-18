{-# LANGUAGE OverloadedStrings #-}
module Main where

import Text.Blaze.Svg.Renderer.Text (renderSvg)

import Web.Scotty
import Renderer
import Shapes
import Debug.Trace

main = scotty 3000 $ do
  get "/" $ do
    file "./static/index.html"

  post "/svg" $ do
    shapeInput <- param "shapeInput"
    setHeader "Content-Type" "image/svg+xml"
    setHeader "Vary" "Accept-Encoding"
    text $ renderSvg $ drawingsToSvg (read shapeInput :: Drawing)