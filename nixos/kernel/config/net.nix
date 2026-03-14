[
  "--set-str DEFAULT_NET_SCH fq"
  "--set-str DEFAULT_TCP_CONG bbr"
  "-e DEFAULT_BBR"
  "-e DEFAULT_FQ"
  "-e NET_SCH_FQ"
  "-e TCP_CONG_BBR"

  "-m NET_SCH_FQ_CODEL"
  "-m TCP_CONG_CUBIC"

  "-d DEFAULT_CUBIC"
  "-d DEFAULT_FQ_CODEL"
]
