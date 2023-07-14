# tas_mineclone2

This is the monorepo containing our custom mods for MineClone2.

# Mods

-   `packages/minetest2_patcher`
    -   This is a mod that adds a global library to patch the Minetest definitions so that we can access the logic of MineClone2.
-   `packages/replace_stack`
    -   This is a mod that replaces the currently held item stack with another equivalent one when you use it all up.
-   `packages/tas_utils`
    -   This is a utility mod that adds useful functions and libraries for mod development.
-   `packages/veinminer`
    -   See README.md in the package for more information.

# Installation

Clone this repo into the `/worldmods/` directory of a world you want to have it in (or into the `/mods/` directory of a game you want to have it in).
The preferred method of installation is the `worldmods` method because it doesn't require you to manually enable the mods in the Minetest configuration screen.
