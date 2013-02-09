# Echotron

Echotron is a WebGL semantic and extensible music visualizer.

![](http://media.tumblr.com/378c7af6967e6cf2175e8f6c3e07a322/tumblr_inline_mhlz6sjZEn1qz4rgp.jpg)

* [Online Demo](dl.dropbox.com/u/485347/echotron/index.html?song=Escape)
* [See an overview in this blog post here](http://beautifulpixel.com/day/2013/02/02)


## Running it locally

**Prerequisites:**
* node.js
* npm
* CoffeeScript _(for the moment)_
* WebGL capable browser

If you have the above squared away, then you are ready to get your own local Echotron server.

1. Clone the repository, cd into project directory.
2. Install npm dependencies: `npm install`
3. Start the local server: `coffee bin/echotron server`
4. Point your browser to: `http://localhost:3001/`

## Anatomoy of the Echotron

Echotron has 3 pools of layers. When creating each scene, a random layer of each type is chosen and composited together.

* **Background:** Renders first, paints entire frame.
* **Midground:** Renders second, typically textures or adorns background.
* **Foreground:** Renders last, typically some sort of object animating front and center

In the `echoes/` directory is a directory for each of these types.  Each layer gets it's own folder within those. Simply adding a directory for a new layer type in the correct directory will cause the server to find it, package it, and expose it to the browser.

Most layers will have at least 3 files:
* **main.coffee:** The JavaScript that powers the layer.
* **vert.glsl:** A vertex shader.
* **frag.glsl:** A fragment shader.

When working on a layer, you can force the randomizer to choose the layer you are working on every time with some query string shenanigans.

* `http://localhost:3001/?fore=foregroundexample`
* `http://localhost:3001/?mid=mymidgroundlayer`
* `http://localhost:3001/?mid=somebackground`
* `http://localhost:3001/?fore=abc&mid=def&back=xyz`
* `http://localhost:3001/?fore=abc&mid=_&back=_` _(hides mid and back entirely)_


## Learning by example

The project comes with an example which, while not very pretty, should lay out the foundation for you to understand how a layer works.

Simply change the name of the folder at:

    echoes/foreground/_example

To:

    echoes/foreground/example

Now, with the server running, navigate to:

    http://localhost:3001/?fore=example

You should see the `example` layer as a spinning, color changing, cube as the foreground over random mid ground and background layers.

Now you can tweak the content of the files in the `example` directory, and figure out how things work in the Echotron.


## Adding your own music

Echotron music must be pre-processed by **Echonest**.

1. [Signup for an Echonest API key](http://developer.echonest.com/account/register)
2. Copy `echonest.example.json` to `echonest.json`.
3. In `echonest.json` replace `YOUR_API_KEY_HERE` with your actual api key.
4. Run the upload script: `coffee upload.coffee "path/to/someSong.m4a" ShortSongName` (only unprotected `m4a` currently supported)
5. Wait a minute or two for uploading plus analyzation on their servers.
5. When it completes you should have an `ShortSongName.m4a` and `ShortSongName.json` files in your `songs` directory.
6. To play the song with visuals, simply navigate to: `http://localhost:3001/?song=ShortSongName`

## Contributing

Eventually, there is plans to treat layers more like content with support for keeping them in a database on a server somewhere.

But for now, I encourage anyone simply fork this repo, make some really cool layers, and send me back a pull request.