# tas_mineclone2

This is the monorepo containing our custom mods for MineClone2.

# Mods

-   `packages/minetest2_patcher`
    -   This is a mod that adds a global library to patch the Minetest definitions so that we can access the logic of MineClone2.
-   `packages/inventory_enhancements`
    -   This is a modpack that adds some enhancements to the inventory system.
-   `packages/tas_utils`
    -   This is a mod which adds a function to simulate `require` so that other mods can split their code into multiple files without having to use `dofile`.

# Installation

Clone this repo into the `/worldmods/` directory of a world you want to have it in (or into the `/mods/` directory of a game you want to have it in).
The preferred method of installation is the `worldmods` method because it doesn't require you to manually enable the mods in the Minetest configuration screen.
