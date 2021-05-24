# Making a custom level

Download and install Godot. They have versions for [Linux](https://godotengine.org/download/linux), 
[MacOSX](https://godotengine.org/download/osx), and [Windows](https://godotengine.org/download/windows)

Clone this repo
```
git clone git@github.com:SquadGames/Platformer.git
```

Open the project in Godot
1. Click `Import`
2. Browse to the `project.godot` file in the repo you cloned in the previous step
3. Click `Import and Edit`


You'll see something like this.
![making_a_level_0](https://user-images.githubusercontent.com/471702/119154123-7d0dc280-ba17-11eb-99fa-27881a9fbcdd.png)

In the bottom left you'll find the `FileSystem`. Open up the `levels` folder and duplicate `blank_level.tscn` by right clicking on it and selecting `duplicate...`

Name your level whatever unique name you want and click `Duplicate`.

Find your new file in the `levels` folder and double click it to open it in the editor. It should look like this.
![making_a_level_1](https://user-images.githubusercontent.com/471702/119155139-792e7000-ba18-11eb-99d4-323beef1702b.png)

There will be a grid in the center pane where you can paint in your tiles, and a set of tiles to the right. 
You can resize the areas to your liking by dragging the separater between them.

The player will spawn at (0, 0) as marked by the "+" and where the x and y axis lines cross, The player will
"Fall off the world" anywere lower than Y=200 (that's below (0, 0) as Godot makes down positive in the Y direction.

Paint in tiles (they all come with appropriate collision detection) by left clicking in the grid, and remove them by right clicking.

## Testing your level

Once you have something you are happy with and want to try out, click the "play button" at the top right of the editor. The game will load up and you'll see a list of levels you could play. Since this level has not been contributed to the Squad Games content network yet you'll type in the name of your level (without the file extension) into the local level field and click `local level`.
![making_a_level_2](https://user-images.githubusercontent.com/471702/119156216-a3ccf880-ba19-11eb-972b-6dd1a97ebcd1.png)

That will load up your level for you to try out.

## Contributing your level

When you are ready to submit your level to the Squad Games content network for anyone to play, add your level name to the list in `worlds/default_world.json` 
then open a pull request in this repo.

Once that PR is merged into `main` it'll be available in the game for everyone!
