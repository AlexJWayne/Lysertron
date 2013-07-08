# Lysertron

Lysertron is a WebGL collborative, semantic and extensible music visualizer.  You can contribute your own technical art to be mixed with the work of other.

![](http://media.tumblr.com/378c7af6967e6cf2175e8f6c3e07a322/tumblr_inline_mhlz6sjZEn1qz4rgp.jpg)

* [Lysertron Website](http://lysertron.com/)


## Getting started

**Prerequisites:**
* node.js
* npm
* CoffeeScript _(for the moment)_
* WebGL capable browser

If you have the above squared away, then you are ready to get your own local Lysertron server.

1. Install the npm module globally: `npm install -g lysteron`
2. Create a project: `lysertron supercool_project_name`
3. Change into the new project directory: `cd supercool_project_name`
3. Start the local server: `lysertron`
4. Point your browser to: `http://localhost:3001/`

You should now see some pretty lights.  Some layers are provided in the framework for context, and others are simple examples for you edit.

## Anatomoy of the Lysertron

Lysertron has 3 pools of layers. When creating each scene, a random layer of each type is chosen and composited together.

* **Background:** Renders first, paints entire frame.
* **Midground:** Renders second, typically textures or adorns background.
* **Foreground:** Renders last, typically some sort of object animating front and center

In your project there is a directory for each of these types.  Each layer gets it's own folder within those. Simply adding a directory for a new layer type in the correct directory will cause the server to find it, package it, and expose it to the browser.  The name of this directory is the name of the layer.

Most layers will have at least 3 files:
* **main.coffee:** The JavaScript that powers the layer.
* **vert.glsl:** A vertex shader.
* **frag.glsl:** A fragment shader.

When working on a layer, you can force the randomizer to choose the layer you are working on every time with some query string parameters.

* `http://localhost:3001/?fore=foregroundexample`
* `http://localhost:3001/?mid=mymidgroundlayer`
* `http://localhost:3001/?mid=somebackground`
* `http://localhost:3001/?fore=abc&mid=def&back=xyz`
* `http://localhost:3001/?fore=abc&mid=_&back=_` _(hides mid and back entirely)_

## Learning by example

The project comes with 3 examples which, while not very pretty, should lay out the foundation for you to understand how a layer works.

To see all examples at once simply navigate to:

    http://localhost:3001/?fore=example&mid=example&back=example

You should see the forground layer as a spinning, color changing cube. You should see the midground as a grid of smaller cubes. And you should see a background of solid changing color.

Now you can tweak the content of the files in these `example` directories, and figure out how things work in the Lysertron.

## Publishing

When you have a master piece ready to go, you can publish the layer to http://lysertron.com/ so others can view it.

1. Make sure you have have registered for a user account on http://lysertron.com/.
2. Run `lysertron publish` form the root of your project.
3. When prompted, enter your API key available here: http://lysertron.com/users/edit

Now every layer you have created in your `background`, `midground` and `foreground` directories will be compiled and submitted to the server.

But be patient, for now there is a review process in place.  If deemed worthy, the layer will be approved and will enter the rotation of layers available on the homepage.  This approval is necesary since many peoples code must play nice with each other.  If one layer raises exceptions, it could kill the entire visualization.  Also, noone wants this thing covered in penis.  The plan is to have better community review tools, coming soon...

## Adding your own music

Stay tuned...