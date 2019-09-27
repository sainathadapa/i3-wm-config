#!/bin/bash
# from https://github.com/chjj/compton/issues/530
compton --backend glx --glx-fshader-win "$(cat ~/.i3/utils/gsls_script)"

