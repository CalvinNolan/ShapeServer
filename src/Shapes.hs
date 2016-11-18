module Shapes(
  Shape(..), Point, Vector(..), Transform(..), Drawing, Matrix(..),
  point, getX, getY,
  StyleSheet(..), StrokeWidth(..), StrokeColour(..), FillColour(..),
  styleSheet, strokeWidth, strokeColour, fillColour,
  getStrokeWidth, getStrokeColour, getFillColour,
  empty, circle, square,
  identity, translate, rotate, scale
  )  where

-- Utilities

data Vector = Vector Double Double
              deriving (Show, Read)
vector = Vector

cross :: Vector -> Vector -> Double
cross (Vector a b) (Vector a' b') = a * a' + b * b'

mult :: Matrix -> Vector -> Vector
mult (Matrix r0 r1) v = Vector (cross r0 v) (cross r1 v)

invert :: Matrix -> Matrix
invert (Matrix (Vector a b) (Vector c d)) = matrix (d / k) (-b / k) (-c / k) (a / k)
  where k = a * d - b * c
        
-- 2x2 square matrices are all we need.
data Matrix = Matrix Vector Vector
              deriving (Show, Read)

matrix :: Double -> Double -> Double -> Double -> Matrix
matrix a b c d = Matrix (Vector a b) (Vector c d)

getX (Vector x y) = x
getY (Vector x y) = y

-- Shapes

type Point  = Vector

point :: Double -> Double -> Point
point = vector


data Shape = Empty 
           | Circle 
           | Square
             deriving (Show, Read)

empty, circle, square :: Shape

empty = Empty
circle = Circle
square = Square

-- StyleSheets

data StrokeWidth = StrokeWidth Integer
                   deriving (Show, Read)
strokeWidth = StrokeWidth

data StrokeColour = StrokeColour Integer Integer Integer
                    deriving (Show, Read)
strokeColour = StrokeColour

data FillColour = FillColour Integer Integer Integer
                  deriving (Show, Read)
fillColour = FillColour

data StyleSheet = StyleSheet StrokeWidth StrokeColour FillColour
                  deriving (Show, Read)
styleSheet = StyleSheet

getStrokeWidth (StyleSheet (StrokeWidth width) _ _) = width
getStrokeColour (StyleSheet _ (StrokeColour r g b) _ ) = (r, g, b)
getFillColour (StyleSheet _ _ (FillColour r g b)) = (r, g, b)

-- Transformations

data Transform = Identity
           | Translate Vector
           | Scale Vector
           | Rotate Double
             deriving (Show, Read)

identity = Identity
translate = Translate
scale = Scale
rotate = Rotate

transform :: Transform -> Point -> Point
transform Identity                   x = id x
transform (Translate (Vector tx ty)) (Vector px py)  = Vector (px - tx) (py - ty)
transform (Scale (Vector tx ty))     (Vector px py)  = Vector (px / tx)  (py / ty)
transform (Rotate d)                 p = (invert (matrix (cos d) (-sin d) (sin d) (cos d))) `mult` p

-- Drawings

type Drawing = [([Transform], Shape, StyleSheet)]
