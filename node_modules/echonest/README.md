echonest.js
=============

A node.js client for the [Echonest API](http://developer.echonest.com/docs/v4/).

[![Build Status](https://secure.travis-ci.org/badamson/node-echonest.png?branch=master)](http://travis-ci.org/badamson/node-echonest)

Installation
------------

To use it with node:

    npm install echonest

Get [an API key](http://developer.echonest.com/docs/v4/#keys).

### example usage in javascript

    echonest = require('echonest');
    var myNest = new echonest.Echonest({
        api_key: 'XXX YOUR API KEY XXX'
    });

    myNest.artist.familiarity({
        name: 'portishead'
    }, function (error, response) {
        if (error) {
            console.log(error, response);
        } else {
            console.log('familiarity:', response.artist.familiarity);
            // see the whole response
            console.log('response:', response);
        }
    });

output:

    familiarity: 0.8310873556337086
    response: { status: { version: '4.2', code: 0, message: 'Success' },
        artist: 
    { familiarity: 0.8310873556337086,
            id: 'ARJVTD81187FB51621',
            name: 'Portishead' } }

To search with multiple buckets (or descriptions, styles, moods), [use an array](https://github.com/badamson/node-echonest/blob/master/test/v4/testMultibucket.coffee): `style: ['lounge', 'metal']`.

The tests touch every endpoint of the live API--including uploading a tune to [track/upload](http://developer.echonest.com/docs/v4/track.html#upload)--so [see them](https://github.com/badamson/node-echonest/tree/master/test/v4) for real examples. They're in [coffeescript](http://coffeescript.org/). You'll also need to visit the [Echonest API Documentation](http://developer.echonest.com/docs/v4) to see what parameters each method accepts and what to expect in the response.

There's some pretty neat stuff in [playlist generation](http://developer.echonest.com/docs/v4/playlist.html#static) (echonest is used by [Spotify radio](http://venturebeat.com/2011/12/16/echo-nest-spotify/)) and [song search](http://developer.echonest.com/docs/v4/song.html#search).

Contributing
------------

* clone
* install dev dependencies -- `npm install`
* install [rake](http://rubygems.org/gems/rake)
* run the tests -- `rake test`

The echonest.js file distributed by npm is generated from coffeescript, and not checked into the repository. To see it, run `rake build`.

It could use some fancier handling of [echonest's response codes](http://developer.echonest.com/docs/v4/index.html#response-codes). It could also probably work outside node.js in a browser without too much work. It's missing some of the slicker stuff from [other client libraries](http://developer.echonest.com/client_libraries.html).

Exploring
---------

The default callback logs errors and responses. These are the loudest 15 songs from the southern hemisphere in d minor (the saddest of all keys), from the coffeescript repl:

    coffee> echonest = require 'echonest'
    { Echonest: [Function: Echonest] }
    coffee> mynest = new echonest.Echonest(api_key: 'XXX')
    { api_key: 'XXX',
      api_version: 'v4',
      host: 'http://developer.echonest.com',
      jsonclient: {},
      song:
       { search: [Function],
         profile: [Function],
         identify: [Function] },
      artist:
       { biographies: [Function],
         blogs: [Function],
         familiarity: [Function],
         hotttnesss: [Function],
         images: [Function],
         list_terms: [Function],
         news: [Function],
         profile: [Function],
         reviews: [Function],
         search: [Function],
         extract: [Function],
         songs: [Function],
         similar: [Function],
         suggest: [Function],
         terms: [Function],
         top_hottt: [Function],
         top_terms: [Function],
         twitter: [Function],
         urls: [Function],
         video: [Function] },
      track:
       { analyze: [Function],
         profile: [Function],
         upload: [Function] },
      playlist:
       { basic: [Function],
         static: [Function],
         dynamic: [Function],
         session_info: [Function] },
      catalog:
       { create: [Function],
         update: [Function],
         status: [Function],
         profile: [Function],
         read: [Function],
         feed: [Function],
         list: [Function],
         delete: [Function] } }
    coffee> # loudest songs from the southern hemisphere in d minor
    coffee> mynest.song.search(sort: 'loudness-desc', max_latitude: 0, key: 'd', mode: 0) 
    err:  [Error: Bad status code from server: 400]
    data:  { status:
       { version: '4.2',
         code: 5,
         message: 'key - Invalid value for parameter: "key" must be a whole number' } }
    coffee> # loudest songs from the southern hemisphere in d minor, take 2
    coffee> mynest.song.search(sort: 'loudness-desc', max_latitude: 0, key: 2, mode: 0)
    err:  null
    data:  { status: { version: '4.2', code: 0, message: 'Success' },
      songs:
       [ { artist_id: 'AROJN321187B9A1967',
           id: 'SOHSSIY12D8578F65A',
           artist_name: 'Sissy Spacek',
           title: 'Bone Flour' },
         { artist_id: 'ARYSZJY1187B9AA68B',
           id: 'SOYQFVQ131343A55FE',
           artist_name: 'Prurient',
           title: 'Troubled Sleep' },
         { artist_id: 'ARG1JWO1187B993356',
           id: 'SOZZDMT12A8C145013',
           artist_name: 'Massimo',
           title: 'Hello Dirty 1' },
         { artist_id: 'ARTG2FK1187B99A5B2',
           id: 'SODBQCA12AB0183BA2',
           artist_name: 'Landed',
           title: 'FM 91.1' },
         { artist_id: 'ARWDKKI130D26542D8',
           id: 'SOMGUYA131F71D6F1A',
           artist_name: 'Fucked',
           title: 'Lloyd+Robbie3' },
         { artist_id: 'AREBLP31187FB4F35F',
           id: 'SOKJANR13152A73068',
           artist_name: 'Merzbow',
           title: 'Minotaurus' },
         { artist_id: 'ARCMHNT12F54FADAC1',
           id: 'SOBOEME130516E3532',
           artist_name: 'Wenaki',
           title: 'Velocity' },
         { artist_id: 'ARCMHNT12F54FADAC1',
           id: 'SOYSVXP1316771415E',
           artist_name: 'Wenaki',
           title: 'Velocity' },
         { artist_id: 'AR1D1ML1187B98C004',
           id: 'SOMEYIT130516E0457',
           artist_name: 'Gerritt & John Wiese',
           title: 'Untitled' },
         { artist_id: 'AR1D1ML1187B98C004',
           id: 'SOLNVGU12D9F521519',
           artist_name: 'Gerritt & John Wiese',
           title: 'Untitled' },
         { artist_id: 'AR1D1ML1187B98C004',
           id: 'SOQJPAN13134386EFE',
           artist_name: 'Gerritt & John Wiese',
           title: 'Untitled' },
         { artist_id: 'ARTPWDY11C8A416B06',
           id: 'SOUECOP131343A19BA',
           artist_name: 'Faux Pride',
           title: 'YouSuckDotCom' },
         { artist_id: 'ARUCSL71187B98EC94',
           id: 'SOSUCKF12AB018AA36',
           artist_name: 'Jason Crumer',
           title: 'III. Betrayal After Betrayal' },
         { artist_id: 'ARXMWHU122C86777D1',
           id: 'SOOYLHL130516DD3AD',
           artist_name: 'Big Deformed Head',
           title: 'Most Triumphant Motherfucker...and I Use the Term Triumphant Loo' },
         { artist_id: 'ARMBMKW1187FB5A735',
           id: 'SOBFKVK12AF7299AB9',
           artist_name: 'Autotrash',
           title: 'Sex Ape' } ] }
