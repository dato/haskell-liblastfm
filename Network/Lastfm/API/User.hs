-- | User API module
{-# OPTIONS_HADDOCK prune #-}
module Network.Lastfm.API.User
  ( getArtistTracks, getBannedTracks, getEvents, getFriends, getInfo, getLovedTracks
  , getNeighbours, getNewReleases, getPastEvents, getPersonalTags, getPlaylists, getRecentStations
  , getRecentTracks, getRecommendedArtists, getRecommendedEvents, getShouts, getTopAlbums
  , getTopArtists, getTopTags, getTopTracks, getWeeklyAlbumChart, getWeeklyArtistChart
  , getWeeklyChartList, getWeeklyTrackChart, shout
  ) where

import Control.Monad (void)
import Control.Monad.Error (runErrorT)
import Network.Lastfm

-- | Get a list of tracks by a given artist scrobbled by this user, including scrobble time. Can be limited to specific timeranges, defaults to all time.
--
-- More: <http://www.lastfm.ru/api/show/user.getArtistTracks>
getArtistTracks :: User -> Artist -> Maybe From -> Maybe To -> Maybe Page -> APIKey -> Lastfm Response
getArtistTracks user artist startTimestamp endTimestamp page apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getArtistTracks")
  , "user" ?< user
  , "artist" ?< artist
  , "startTimestamp" ?< startTimestamp
  , (#) page
  , "endTimestamp" ?< endTimestamp
  , (#) apiKey
  ]

-- | Returns the tracks banned by the user.
--
-- More: <http://www.lastfm.ru/api/show/user.getBannedTracks>
getBannedTracks :: User -> Maybe Page -> Maybe Limit -> APIKey -> Lastfm Response
getBannedTracks user page limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getBannedTracks")
  , "user" ?< user
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get a list of upcoming events that this user is attending.
--
-- Mpre: <http://www.lastfm.ru/api/show/user.getEvents>
getEvents :: User -> Maybe Page -> Maybe Limit -> Maybe FestivalsOnly -> APIKey -> Lastfm Response
getEvents user page limit festivalsOnly apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getEvents")
  , "user" ?< user
  , (#) page
  , (#) limit
  , "festivalsonly" ?< festivalsOnly
  , (#) apiKey
  ]

-- | Get a list of the user's friends on Last.fm.
--
-- More: <http://www.lastfm.ru/api/show/user.getFriends>
getFriends :: User -> Maybe RecentTracks -> Maybe Page -> Maybe Limit -> APIKey -> Lastfm Response
getFriends user recentTracks page limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getFriends")
  , "user" ?< user
  , "recenttracks" ?< recentTracks
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get information about a user profile.
--
-- More: <http://www.lastfm.ru/api/show/user.getInfo>
getInfo :: Maybe User -> APIKey -> Lastfm Response
getInfo user apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getInfo")
  , "user" ?< user
  , (#) apiKey
  ]

-- | Get tracks loved by a user.
--
-- More: <http://www.lastfm.ru/api/show/user.getLovedTracks>
getLovedTracks :: User -> Maybe Page -> Maybe Limit -> APIKey -> Lastfm Response
getLovedTracks user page limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getLovedTracks")
  , "user" ?< user
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get a list of a user's neighbours on Last.fm.
--
-- More: <http://www.lastfm.ru/api/show/user.getNeighbours>
getNeighbours :: User -> Maybe Limit -> APIKey -> Lastfm Response
getNeighbours user limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getNeighbours")
  , "user" ?< user
  , (#) limit
  , (#) apiKey
  ]

-- | Gets a list of forthcoming releases based on a user's musical taste.
--
-- More: <http://www.lastfm.ru/api/show/user.getNewReleases>
getNewReleases :: User -> Maybe UseRecs -> APIKey -> Lastfm Response
getNewReleases user useRecs apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getNewReleases")
  , "user" ?< user
  , "userecs" ?< useRecs
  , (#) apiKey
  ]

-- | Get a paginated list of all events a user has attended in the past.
--
-- More: <http://www.lastfm.ru/api/show/user.getPastEvents>
getPastEvents :: User -> Maybe Page -> Maybe Limit -> APIKey -> Lastfm Response
getPastEvents user page limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getPastEvents")
  , "user" ?< user
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get the user's personal tags.
--
-- More: <http://www.lastfm.ru/api/show/user.getPersonalTags>
getPersonalTags :: User
                -> Tag
                -> TaggingType
                -> Maybe Page
                -> Maybe Limit
                -> APIKey
                -> Lastfm Response
getPersonalTags user tag taggingType page limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getPersonalTags")
  , "user" ?< user
  , (#) tag
  , "taggingtype" ?< taggingType
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get a list of a user's playlists on Last.fm.
--
-- More: <http://www.lastfm.ru/api/show/user.getPlaylists>
getPlaylists :: User -> APIKey -> Lastfm Response
getPlaylists user apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getPlaylists")
  , "user" ?< user
  , (#) apiKey
  ]

-- | Get a list of the recent Stations listened to by this user.
--
-- More: <http://www.lastfm.ru/api/show/user.getRecentStations>
getRecentStations :: User -> Maybe Page -> Maybe Limit -> APIKey -> SessionKey -> Secret -> Lastfm Response
getRecentStations user page limit apiKey sessionKey secret = runErrorT . callAPIsigned secret $
  [ (#) (Method "user.getRecentStations")
  , "user" ?< user
  , (#) page
  , (#) limit
  , (#) apiKey
  , (#) sessionKey
  ]

-- | Get a list of the recent tracks listened to by this user. Also includes the currently playing track with the nowplaying="true" attribute if the user is currently listening.
--
-- More: <http://www.lastfm.ru/api/show/user.getRecentTracks>
getRecentTracks :: User -> Maybe Page -> Maybe Limit -> Maybe From -> Maybe To -> APIKey -> Lastfm Response
getRecentTracks user page limit from to apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getRecentTracks")
  , "user" ?< user
  , (#) page
  , (#) limit
  , (#) from
  , (#) to
  , (#) apiKey
  ]

-- | Get Last.fm artist recommendations for a user.
--
-- Mpre: <http://www.lastfm.ru/api/show/user.getRecommendedArtists>
getRecommendedArtists :: Maybe Page -> Maybe Limit -> APIKey -> SessionKey -> Secret -> Lastfm Response
getRecommendedArtists page limit apiKey sessionKey secret = runErrorT . callAPIsigned secret $
  [ (#) (Method "user.getRecommendedArtists")
  , (#) page
  , (#) limit
  , (#) apiKey
  , (#) sessionKey
  ]

-- | Get a paginated list of all events recommended to a user by Last.fm, based on their listening profile.
--
-- More: <http://www.lastfm.ru/api/show/user.getRecommendedEvents>
getRecommendedEvents :: Maybe Page -> Maybe Limit -> APIKey -> SessionKey -> Secret -> Lastfm Response
getRecommendedEvents page limit apiKey sessionKey secret = runErrorT . callAPIsigned secret $
  [ (#) (Method "user.getRecommendedEvents")
  , (#) page
  , (#) limit
  , (#) apiKey
  , (#) sessionKey
  ]

-- | Get shouts for this user. Also available as an rss feed.
--
-- More: <http://www.lastfm.ru/api/show/user.getShouts>
getShouts :: User -> Maybe Page -> Maybe Limit -> APIKey -> Lastfm Response
getShouts user page limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getShouts")
  , "user" ?< user
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get the top albums listened to by a user. You can stipulate a time period. Sends the overall chart by default.
--
-- More: <http://www.lastfm.ru/api/show/user.getTopAlbums>
getTopAlbums :: User -> Maybe Period -> Maybe Page -> Maybe Limit -> APIKey -> Lastfm Response
getTopAlbums user period page limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getTopAlbums")
  , "user" ?< user
  , "period" ?< period
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get the top artists listened to by a user. You can stipulate a time period. Sends the overall chart by default.
--
-- More: <http://www.lastfm.ru/api/show/user.getTopArtists>
getTopArtists :: User -> Maybe Period -> Maybe Page -> Maybe Limit -> APIKey -> Lastfm Response
getTopArtists user period page limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getTopArtists")
  , "user" ?< user
  , "period" ?< period
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get the top tags used by this user.
--
-- More: <http://www.lastfm.ru/api/show/user.getTopTags>
getTopTags :: User -> Maybe Limit -> APIKey -> Lastfm Response
getTopTags user limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getTopTags")
  , "user" ?< user
  , (#) limit
  , (#) apiKey
  ]

-- | Get the top tracks listened to by a user. You can stipulate a time period. Sends the overall chart by default.
--
-- More: <http://www.lastfm.ru/api/show/user.getTopTracks>
getTopTracks :: User -> Maybe Period -> Maybe Page -> Maybe Limit -> APIKey -> Lastfm Response
getTopTracks user period page limit apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getTopTracks")
  , "user" ?< user
  , "period" ?< period
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

-- | Get an album chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent album chart for this user.
--
-- More: <http://www.lastfm.ru/api/show/user.getWeeklyAlbumChart>
getWeeklyAlbumChart :: User -> Maybe From -> Maybe To -> APIKey -> Lastfm Response
getWeeklyAlbumChart user from to apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getWeeklyAlbumChart")
  , "user" ?< user
  , (#) from
  , (#) to
  , (#) apiKey
  ]

-- | Get an artist chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent artist chart for this user.
--
-- More: <http://www.lastfm.ru/api/show/user.getWeeklyArtistChart>
getWeeklyArtistChart :: User -> Maybe From -> Maybe To -> APIKey -> Lastfm Response
getWeeklyArtistChart user from to apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getWeeklyArtistChart")
  , "user" ?< user
  , (#) from
  , (#) to
  , (#) apiKey
  ]

-- | Get a list of available charts for this user, expressed as date ranges which can be sent to the chart services.
--
-- More: <http://www.lastfm.ru/api/show/user.getWeeklyChartList>
getWeeklyChartList :: User -> APIKey -> Lastfm Response
getWeeklyChartList user apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getWeeklyChartList")
  , "user" ?< user
  , (#) apiKey
  ]

-- | Get a track chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent track chart for this user.
--
-- More: <http://www.lastfm.ru/api/show/user.getWeeklyTrackChart>
getWeeklyTrackChart :: User -> Maybe From -> Maybe To -> APIKey -> Lastfm Response
getWeeklyTrackChart user from to apiKey = runErrorT . callAPI $
  [ (#) (Method "user.getWeeklyTrackChart")
  , "user" ?< user
  , (#) from
  , (#) to
  , (#) apiKey
  ]

-- | Shout on this user's shoutbox.
--
-- More: <http://www.lastfm.ru/api/show/user.shout>
shout :: User -> Message -> APIKey -> SessionKey -> Secret -> Lastfm ()
shout user message apiKey sessionKey secret = runErrorT . void . callAPIsigned secret $
  [ (#) (Method "user.shout")
  , "user" ?< user
  , "message" ?< message
  , (#) apiKey
  , (#) sessionKey
  ]
