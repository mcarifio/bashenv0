# todo

* use BASH_ENV to load `__fw__.sh` implicitly. ... Tried it, turns out to be a bad idea. Added oneliner
  to `bashenv/bin/__fw__.sh` that will source ~/.bash_login iff BASHENV is undefined. This failed too.
  Needed to be added to `bashenv/bin/__fw__template__.sh` otherwise `__fw__.sh` can't be sourced.
  
  
