#!/usr/local/bin/coffee

fs = require('fs')
spawn = require('child_process').spawn
dirname = require('path').dirname
mkdirp = require('mkdirp')
rimraf = require('rimraf')
argv = require('optimist')
  .usage("pb <file or directory name>")
  .demand(1)
  .argv

EDITOR = process.env.PB_EDITOR ? process.env.EDITOR ? '/usr/bin/vim'
LS = process.env.PB_LS ? '/bin/ls -G'

path = argv._[0].toString()

stat = (path) ->
  # Stat sync a file, returning null if it
  # doesn't exist.
  try
    return fs.statSync path
  catch e
    if e.code is 'ENOENT'
      return null

    console.error e.toString()
    process.exit 1

stats = stat path

createdPath = null
unless stats
  # The file does not exist, if it's directory does we'll just
  # open it in the editor.  If not, we'll recursivly create
  # it.
  dir = dirname path

  unless stat dir
    # If the directory does not already exist, we create it
    # remembering the first dir we created, so we can delete it
    # if the user doesn't end up saving their file.
    createdPath = mkdirp.sync dirname path

if stats?.isDirectory()
  command = LS
else
  command = EDITOR

# This is not going to properly handle quoted or escaped commands
command_parts = command.split(' ')

command = command_parts[0]
args = command_parts[1..]
args.push path

proc = spawn command, args,
  stdio: 'inherit'

proc.on 'exit', (code) ->
  if createdPath and not stat path
    # We created some dirs, and the user didn't end up saving their
    # file, let's clean up.
    rimraf.sync createdPath

  process.exit code

