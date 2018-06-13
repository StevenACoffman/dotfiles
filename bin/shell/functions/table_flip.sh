#!/bin/sh
flip() {
  echo;
  echo -en "( º_º）  ┬─┬   \r"; sleep .2;
  echo -en " ( º_º） ┬─┬   \r"; sleep .2;
  echo -en "  ( ºДº）┬─┬   \r"; sleep 1.2;
  echo -en "  (╯'Д'）╯︵⊏   \r"; sleep .1;
  echo -en "  (╯'□'）╯︵ ⊏  \r"; sleep .1;
  echo     "  (╯°□°）╯︵ ┻━┻"; sleep .1;
}


table () {
  case "${1}" in
    flip)
      flip
    ;;
    set)
      echo "┬─┬﻿ ノ( ゜-゜ノ)"
    ;;
    man)
      echo "(╯°Д°）╯︵ /(.□ . \)"
    ;;
    bear)
      echo "ʕノ•ᴥ•ʔノ ︵ ┻━┻"
    ;;
    jedi)
      echo "(._.) ~ ︵ ┻━┻"
    ;;
    pudgy)
      echo "(ノ ゜Д゜)ノ ︵ ┻━┻"
    ;;
    battle)
      echo "(╯°□°)╯︵ ┻━┻ ︵ ╯(°□° ╯)"
    ;;
    rage)
      echo "‎(ﾉಥ益ಥ）ﾉ﻿ ┻━┻"
    ;;
    herc)
      echo "(/ .□.)\ ︵╰(゜Д゜)╯︵ /(.□. \)"
    ;;
    *)
      echo "Unknown table" >&2
      echo "Try:" >&2
      echo -e "  flip" >&2
      echo -e "  set" >&2
      echo -e "  man" >&2
      echo -e "  bear" >&2
      echo -e "  jedi" >&2
      echo -e "  pudgy" >&2
      echo -e "  battle" >&2
      echo -e "  rage" >&2
      echo -e "  herc" >&2
    ;;
  esac
  return 0
}
