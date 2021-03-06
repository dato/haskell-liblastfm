{-# LANGUAGE CPP #-}
{-# LANGUAGE TemplateHaskell #-}
-- | Venue API module
{-# OPTIONS_HADDOCK prune #-}
module Network.Lastfm.XML.Venue
  ( getEvents, getPastEvents, search
  ) where

#include "venue.docs"

import Network.Lastfm.Internal
import Network.Lastfm.XML (xmlWrapper)
import qualified Network.Lastfm.API.Venue as API

$(xmlWrapper ["getEvents", "getPastEvents", "search"])

__getEvents__
getEvents ∷ Venue → Maybe FestivalsOnly → APIKey → Lastfm Response

__getPastEvents__
getPastEvents ∷ Venue → Maybe FestivalsOnly → Maybe Page → Maybe Limit → APIKey → Lastfm Response

__search__
search ∷ Venuename → Maybe Page → Maybe Limit → Maybe Country → APIKey → Lastfm Response
