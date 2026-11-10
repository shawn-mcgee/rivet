# Rivet

A platform game built with Godot 4.6.

[Play in your browser](https://shawn-mcgee.github.io/rivet/)

## Controls

- Move: A/D or Left/Right arrows
- Jump: W, Up arrow, or Space

## Development

Open `project.godot` in Godot 4.6 and run the project.

## Deployment

Every push to `main` builds the Web export and deploys it to GitHub Pages.
The deployment can also be started from the Actions tab with **Run workflow**.
The workflow installs Godot 4.6 and its matching web templates, imports the
resources, exports `build/web/index.html`, and publishes the build using the
official GitHub Pages actions. No repository secrets are required.

The Web preset uses the Compatibility renderer with thread support disabled,
so the game runs on GitHub Pages without custom cross-origin isolation headers.

For a local export, install the Godot 4.6 export templates, create `build/web`,
and run:

```sh
godot --headless --editor --import
godot --headless --export-release "Web" build/web/index.html
```

Serve `build/web` over HTTP to test the browser build.
