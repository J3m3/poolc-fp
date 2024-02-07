// Clean programming language: https://wiki.clean.cs.ru.nl/Clean

module hello
import StdEnv

Start :: *World -> *World
Start world
  # (console, world) = stdio world
  # console = fwrites "Hello, World!\n" console
  # (ok, world) = fclose console world
  | not ok = abort "ERROR: cannot close console\n"
  | otherwise = world