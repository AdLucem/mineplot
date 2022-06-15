import Data.List
import System.IO  
import Control.Monad

type Point = (Int, Int)

data Square = Square Point Point Point Point
                deriving (Show, Eq)

mapSquare :: (Point -> Point) -> Square -> Square
mapSquare f (Square p q r s) = Square (f p) (f q) (f r) (f s)

-- | Return 1000 x 1000 square `prqs` around given point
boundingBox :: Point -> Square
boundingBox (x, z) = 
    Square (leastX, leastZ) (leastX, mostZ) (mostX, mostZ) (mostX, leastZ)
    where
        leastX = x - 500
        leastZ = z - 500
        mostX  = x + 500
        mostZ  = z + 500 

-- | round down given co-ordinates
roundDown :: (Float, Float) -> (Int, Int)
roundDown (x, z) = (round x, round z)

-- | convert co-ordinates to chunk
toChunk :: Point -> Point
toChunk (x, z) = 
    let 
        chunker n = round ((fromIntegral n) / 16.0)
    in 
        (chunker x, chunker z)

-- | convert chunks to region
chunkToRegion :: Point -> Point
chunkToRegion (x, z) = 
    let 
        regional n = round ((fromIntegral n) / 32.0)
    in 
        (regional x, regional z)

-- | convert co-ordinates to region
toRegion = chunkToRegion . toChunk

-- | Get all regions bounding a waystone
boundingRegions :: Point -> Square
boundingRegions (x, z) = mapSquare toRegion (boundingBox (x, z))  

-- | get all region values in a given square of regions
allRegionsInSquare :: Square -> [Point]
allRegionsInSquare (Square p q r s) = 
    let
        axisX = [(fst q)..(fst r)]
        axisZ = [(snd p)..(snd q)]
    in 
        [(x, z) | x <- axisX, z <- axisZ]

-- | Get all regions in a 1000 x 1000 block around a waystone
allRegions :: Point -> [Point]
allRegions = allRegionsInSquare . boundingRegions

-- | Get all region files in a 1000 x 1000 block around a waystone
toFile :: Point -> String
toFile (x, z) = "r." ++ (show x) ++ "." ++ (show z) ++ ".mca"

allRegionFiles :: Point -> [String]
allRegionFiles coords = map toFile (allRegions coords)

-- | gets all unique region files enclosing a list of waystones
allUniqueRegionFiles :: [Point] -> [String]
allUniqueRegionFiles listCoords = nub $ concat $ map allRegionFiles listCoords 

-- | Prints all files one file per line
showFiles :: [String] -> String
showFiles files = foldr join "" files
    where
        join = \x y -> x ++ "\n" ++ y

-- | Splits input into list of co-ordinates
readCoords :: String -> [Point]
readCoords s =
    let 
      s' = map words (lines s)
      toPoint (x:y:_) = (read x, read y)
    in 
      map toPoint s' 

main = do 

    -- read contents of file
    handle <- openFile "waystones.txt" ReadMode
    contents <- hGetContents handle

    -- get all region files associated with the waystones
    let regionFiles = (showFiles . allUniqueRegionFiles . readCoords) contents

    -- print all the region files
    putStrLn regionFiles