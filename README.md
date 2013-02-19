pb
=============

`pb ~`

Give it a path, if it's a file it will open it in your editor, if it's a directory it will list it.

Configuration
-------------

You can configure the editor and ls application and flags using environment variables.

Leadit looks first at `PB_EDITOR`, then `EDITOR` environment variables for the editor,
`PB_LS` for ls.

You must use full paths, and can include any applicable command line flags.  Paths with 
spaces will not work properly.
