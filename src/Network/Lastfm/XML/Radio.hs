{-# LANGUAGE CPP #-}
{-# LANGUAGE TemplateHaskell #-}
-- | Radio API module
{-# OPTIONS_HADDOCK prune #-}
module Network.Lastfm.XML.Radio
  ( getPlaylist, search, tune
  ) where

#include "radio.docs"

import Network.Lastfm.Internal
import Network.Lastfm.XML (xmlWrapper)
import qualified Network.Lastfm.API.Radio as API

$(xmlWrapper ["getPlaylist", "search", "tune"])

__getPlaylist__
getPlaylist ∷ Maybe Discovery
            → Maybe RTP
            → Maybe BuyLinks
            → Multiplier
            → Bitrate
            → APIKey
            → SessionKey
            → Secret
            → Lastfm Response

__search__
search ∷ Name → APIKey → Lastfm Response

__tune__
tune ∷ Maybe Language → Station → APIKey → SessionKey → Secret → Lastfm Response
