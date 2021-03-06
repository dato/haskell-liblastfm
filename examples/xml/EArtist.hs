module EArtist (common, auth) where

import Control.Arrow ((|||))
import Control.Monad ((<=<))

import Network.Lastfm
import qualified Network.Lastfm.XML.Artist as Artist

import Kludges

apiKey = APIKey "b25b959554ed76058ac220b7b2e0a026"

addTags :: APIKey -> SessionKey -> Secret -> IO ()
addTags ak sk s = Artist.addTags (Artist "Егор Летов") [Tag "russian"] ak sk s >>= print ||| const (return ())

getCorrection :: IO ()
getCorrection = parse r f "Correction"
  where r = Artist.getCorrection (Artist "Meshugah") apiKey
        f = fmap return . content <=< tag "name" <=< tag "artist" <=< tag "correction" <=< tag "corrections"

getEvents :: IO ()
getEvents = parse r f "First event place"
  where r = Artist.getEvents (Left $ Artist "Meshuggah") Nothing Nothing (Just $ Limit 3) Nothing apiKey
        f = fmap return . content <=< tag "name" <=< tag "venue" <=< tag "event" <=< tag "events"

getImages :: IO ()
getImages = parse r f "First 3 images links"
  where r = Artist.getImages (Left $ Artist "Meshuggah") Nothing Nothing (Just $ Limit 3) Nothing apiKey
        f = mapM (content <=< tag "url") <=< tags "image" <=< tag "images"

getInfo :: IO ()
getInfo = parse r f "Listeners count"
  where r = Artist.getInfo (Left $ Artist "Meshuggah") Nothing Nothing Nothing apiKey
        f = fmap return . content <=< tag "listeners" <=< tag "stats" <=< tag "artist"

getPastEvents :: IO ()
getPastEvents = parse r f "All event artists"
  where r = Artist.getPastEvents (Left $ Artist "Meshugah") (Just $ Autocorrect True) Nothing Nothing apiKey
        f = mapM content <=< tags "artist" <=< tag "artists" <=< tag "event" <=< tag "events"

getPodcast :: IO ()
getPodcast = parse r f "First channel description"
  where r = Artist.getPodcast (Left $ Artist "Meshuggah") Nothing apiKey
        f = fmap return . content <=< tag "description" <=< tag "channel" <=< tag "rss"

getShouts :: IO ()
getShouts = parse r f "Last 5 shouts authors"
  where r = Artist.getShouts (Left $ Artist "Meshuggah") Nothing Nothing (Just $ Limit 5) apiKey
        f = mapM (content <=< tag "author") <=< tags "shout" <=< tag "shouts"

getSimilar :: IO ()
getSimilar = parse r f "7 similar artists"
  where r = Artist.getSimilar (Left $ Artist "Meshuggah") Nothing (Just $ Limit 7) apiKey
        f = mapM (content <=< tag "name") <=< tags "artist" <=< tag "similarartists"

getTags :: IO ()
getTags = parse r f "Егор Летов tags"
  where r = Artist.getTags (Left $ Artist "Егор Летов") Nothing (Left $ User "liblastfm") apiKey
        f = mapM (content <=< tag "name") <=< tags "tag" <=< tag "tags"

getTagsAuth :: APIKey -> SessionKey -> Secret -> IO ()
getTagsAuth ak sk s = parse r f "Егор Летов tags"
  where r = Artist.getTags (Left $ Artist "Егор Летов") Nothing (Right (sk, s)) ak
        f = mapM (content <=< tag "name") <=< tags "tag" <=< tag "tags"

getTopAlbums :: IO ()
getTopAlbums = parse r f "3 most popular albums"
  where r = Artist.getTopAlbums (Left $ Artist "Meshuggah") Nothing Nothing (Just $ Limit 3) apiKey
        f = mapM (content <=< tag "name") <=< tags "album" <=< tag "topalbums"

getTopFans :: IO ()
getTopFans = parse r f "Top fans"
  where r = Artist.getTopFans (Left $ Artist "Meshuggah") Nothing apiKey
        f = mapM (content <=< tag "name") <=< tags "user" <=< tag "topfans"

getTopTags :: IO ()
getTopTags = parse r f "Top tags"
  where r = Artist.getTopTags (Left $ Artist "Meshuggah") Nothing apiKey
        f = mapM (content <=< tag "name") <=< tags "tag" <=< tag "toptags"

getTopTracks :: IO ()
getTopTracks = parse r f "10 most popular tracks"
  where r = Artist.getTopTracks (Left $ Artist "Meshuggah") Nothing Nothing (Just $ Limit 10) apiKey
        f = mapM (content <=< tag "name") <=< tags "track" <=< tag "toptracks"

removeTag :: APIKey -> SessionKey -> Secret -> IO ()
removeTag ak sk s = Artist.removeTag (Artist "Егор Летов") (Tag "russian") ak sk s >>= print ||| const (return ())

search :: IO ()
search = parse r f "12 search results for \"Mesh\" query"
  where r = Artist.search (Artist "Mesh") Nothing (Just $ Limit 12) apiKey
        f = mapM (content <=< tag "name") <=< tags "artist" <=< tag "artistmatches" <=< tag "results"

share :: APIKey -> SessionKey -> Secret -> IO ()
share ak sk s = Artist.share (Artist "Sleep") (Recipient "liblastfm") (Just $ Message "Just listen!") Nothing ak sk s >>= print ||| const (return ())

common :: IO ()
common = do getCorrection
            getEvents
            getImages
            getInfo
            getPastEvents
            getPodcast
            getShouts
            getSimilar
            getTags
            getTopAlbums
            getTopFans
            getTopTags
            getTopTracks
            search

auth :: APIKey -> SessionKey -> Secret -> IO ()
auth ak sk s = do addTags ak sk s
                  getTagsAuth ak sk s
                  removeTag ak sk s
                  share ak sk s
                  -- shout (see User.shout example)
