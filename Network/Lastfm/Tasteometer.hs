module Network.Lastfm.Tasteometer
  ( compare
  ) where

import Control.Exception (throw)
import Prelude hiding (compare)

import Network.Lastfm.Core
import Network.Lastfm.Types ((?<), APIKey, Limit, Value(..))

compare :: Value -> Value -> Maybe Limit -> APIKey -> Lastfm Response
compare value1 value2 limit apiKey
  | isNull value1 = throw $ WrapperCallError "tasteometer.compare" "empty first artists list."
  | isNull value2 = throw $ WrapperCallError "tasteometer.compare" "empty second artists list."
  | isExceededMaximum value1 = throw $ WrapperCallError "tasteometer.compare" "first artists list length has exceeded maximum (100)."
  | isExceededMaximum value2 = throw $ WrapperCallError "tasteometer.compare" "second artists list length has exceeded maximum (100)."
  | otherwise = dispatch $ callAPI "tasteometer.compare"
    [ "type1" ?< type1
    , "type2" ?< type2
    , "value1" ?< value1
    , "value2" ?< value2
    , "limit" ?< limit
    , "api_key" ?< apiKey
    ]
    where type1 = show value1
          type2 = show value2

          isNull :: Value -> Bool
          isNull (ValueUser _) = False
          isNull (ValueArtists as) = null as

          isExceededMaximum :: Value -> Bool
          isExceededMaximum (ValueUser _) = False
          isExceededMaximum (ValueArtists as) = length as > 100

{- `compareGroup' method is deprecated -}
