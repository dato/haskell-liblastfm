-- | Tasteometer API module
{-# OPTIONS_HADDOCK prune #-}
module Network.Lastfm.API.Tasteometer
  ( compare
  ) where

import Control.Monad.Error (runErrorT, throwError)
import Network.Lastfm
import Prelude hiding (compare)

-- | Get a Tasteometer score from two inputs, along with a list of shared artists. If the input is a User some additional information is returned.
--
-- More: <http://www.lastfm.ru/api/show/tasteometer.compare>
compare :: Value -> Value -> Maybe Limit -> APIKey -> Lastfm Response
compare value1 value2 limit apiKey = runErrorT go
  where go
          | isNull value1 = throwError $ WrapperCallError method "empty first artists list."
          | isNull value2 = throwError $ WrapperCallError method "empty second artists list."
          | isExceededMaximum value1 = throwError $ WrapperCallError method "first artists list length has exceeded maximum (100)."
          | isExceededMaximum value2 = throwError $ WrapperCallError method "second artists list length has exceeded maximum (100)."
          | otherwise = callAPI
            [ (#) (Method method)
            , "type1" ?< type1
            , "type2" ?< type2
            , "value1" ?< value1
            , "value2" ?< value2
            , (#) limit
            , (#) apiKey
            ]
            where method = "tasteometer.compare"

                  type1 = show value1
                  type2 = show value2

                  isNull :: Value -> Bool
                  isNull (ValueUser _) = False
                  isNull (ValueArtists as) = null as

                  isExceededMaximum :: Value -> Bool
                  isExceededMaximum (ValueUser _) = False
                  isExceededMaximum (ValueArtists as) = length as > 100
