{ host }:
let
  commonDb = ./common.db;
  modprobedDb = if host == "v7w7r-macmini81" then
    ./macmini81.db
  else if host == "v7w7r-youyeetoox1" then
    ./youyeetoox1.db
  else if host == "v7w7r-rc71l" then
    ./rc71l.db
  else
    ./youyeetoox1.db;
in ''
  export LSMOD=$(mktemp)
  cat "${commonDb}" "${modprobedDb}" | sort > $LSMOD
  (yes "" | make LSMOD=$LSMOD localmodconfig) || true
''
