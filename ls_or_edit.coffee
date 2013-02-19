#!/usr/local/bin/coffee

fs = require('fs')
spawn = require('child_process').spawn
argv = require('optimist')
  .usage("#{ process.argv[0] } <file or directory name>")
  .demand(1)
  .argv

EDITOR = process.env.PB_EDITOR ? process.env.EDITOR ? '/usr/bin/vim'
LS = process.env.PB_LS ? '/bin/ls -G'

path = argv._[0].toString()

try
  stats = fs.statSync path
catch e
  console.error e.toString()
  process.exit 1

if stats.isDirectory()
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
  process.exit code

