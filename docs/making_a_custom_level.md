# Making a custom level

Download and install Godot. They have versions for [Linux](https://godotengine.org/download/linux), 
[MacOSX](https://godotengine.org/download/osx), and [Windows](https://godotengine.org/download/windows)

[Fork](https://docs.github.com/en/github/getting-started-with-github/quickstart/fork-a-repo) this repo and [clone](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository-from-github/cloning-a-repository) a local copy to work with.

Open the project in Godot:
- Click `Import`.
- Browse to the `project.godot` file in the repo you cloned.
- Click `Import and Edit`.

You'll see something like this:
![Godot screen 1](https://user-images.githubusercontent.com/5414803/119717791-c5244f00-be34-11eb-9864-f669b785615a.PNG)

In the bottom left, you'll find the `FileSystem`. Open up the `levels` folder and duplicate `blank_level.tscn` by right clicking on it and selecting `Duplicate...`. Rename the duplicate `test_level.tscn`. Find your new file in the `levels` folder and move it into the `local_testing` folder.

Double click your new `test_level.tscn` file to open it in the editor. It should look like this:
![Godot screen 2](https://user-images.githubusercontent.com/5414803/119718471-9c508980-be35-11eb-9099-9e9e2a9765f1.PNG)

There will be a grid in the center pane and a set of tiles to the right. Select tiles from list to the right and paint them into the center grid to create your level. Remove tiles from the level by right clicking them.

The player will start at (0, 0) as marked by both the "+" and crossing of the x and y axis. The player will
"fall off the world" anywere lower than y=200, or about 12 tiles below the starting position.

## Testing your level

Once you have something you are happy with and want to try out, click the "Play" button at the top right of the editor (the "Play Scene" button will not work). After the game loads up, click "Test Local Level" to try playing through your level.

## Contributing your level

When you are ready to submit your level to Squad Games for anyone to play, add your level name to the list in `worlds/default_world.json`. 
Then open a [pull request](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork) to merge your fork into the `main` branch of this repo.

Once that PR is merged into `main`, it'll be available in the game for everyone!

### If you need help, we're happy to provide. Please reach out in the [Squad Games discord](https://discord.gg/uR86T5Afh2).
