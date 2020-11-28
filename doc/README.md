# bashenv doc

# summary

# caviats

# install, update

# functions, scripts, configuration

# conventions (thinking less)

# workflow

# hacking

## some tips

I think it's useful to create three additional "users": 

* user `git` for hosting git services

* `bashenv` to test changes without ruining the `${USER}` (your own) environment

* [`skippy`]() in case you do ruin `${USER}`'s environment and can't login. Don't forget to make `skippy` a sudoer.
  If you have physical access to your computer, you can forego this step since you can boot in rescue mode and
  drop into a root shell. Any name or alternative login can serve as long as it's not hooked up to `bashenv`: `test`,
  `minimal`, `notbe`. Mine is an homage to the evil twin of President Bush from the Doonesbury comic.


`bashenv/home/.bash_alias` steals a page from python and only executes it's "main" when the user sources it from `${HOME}`.
This allows for experimentation.

