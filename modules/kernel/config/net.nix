{ kernel, lib, ... }: {
  kernel.config.net = with lib.kernel; {
    all = with kernel.config.net; include // denied;

    realtek =
      with kernel.config.utils;
      {
        isDenied ? false,
      }:
      {
        REALTEK_PHY = setupDenial isDenied yes;
        R8169 = setupDenial isDenied yes;
      };

    include = {
      BRIDGE = yes;
      BRIDGE_NETFILTER = yes;
      CFG80211 = yes;
      DEFAULT_BBR = yes;
      DEFAULT_CUBIC = no;
      DEFAULT_HOSTNAME = freeform "v7w7r";
      DEFAULT_TCP_CONG = freeform "bbr";
      INET_AH = yes;
      INET_ESP = yes;
      INET_IPCOMP = yes;
      IP6_NF_MANGLE = no;
      MAC80211 = yes;
      NETFILTER_XTABLES = yes;
      NETFILTER_XT_MATCH_ADDRTYPE = yes;
      NETFILTER_XT_MATCH_COMMENT = yes;
      NETFILTER_XT_MATCH_CONNTRACK = yes;
      NETFILTER_XT_MATCH_MULTIPORT = yes;
      NETFILTER_XT_MATCH_PKTTYPE = yes;
      NETFILTER_XT_MATCH_STATE = yes;
      NETFILTER_XT_TARGET_LOG = yes;
      NETFILTER_XT_TARGET_MASQUERADE = yes;
      NET_FOU = yes;
      NET_SCH_FQ = yes;
      NFT_COMPAT = no;
      NFT_FIB_INET = yes;
      NFT_FIB_IPV4 = yes;
      NFT_MASQ = yes;
      NFT_NAT = yes;
      NFT_REJECT = yes;
      NF_CONNTRACK = yes;
      NF_NAT = yes;
      NF_TABLES = yes;
      PACKET = yes;
      TCP_CONG_BBR = yes;
      TUN = yes;
      UNIX_DIAG = yes;
      VETH = yes;
      VHOST_VSOCK = yes;
      VSOCKETS = yes;
    };
    /*
      (dynamic-denial {
        inherit config;
        attr = "TCP_CONG";
        excludes = [
          "ADVANCED"
          "CUBIC"
          "BBR"
        ];
      })
    */
    denied = lib.mkMerge [
      #ACT / CLS
      {
        NET_ACT_CONNMARK = no;
        NET_ACT_CSUM = no;
        NET_ACT_CT = no;
        NET_ACT_CTINFO = no;
        NET_ACT_GACT = no;
        NET_ACT_GATE = no;
        NET_ACT_IFE = no;
        NET_ACT_MPLS = no;
        NET_ACT_NAT = no;
        NET_ACT_PEDIT = no;
        NET_ACT_POLICE = no;
        NET_ACT_SAMPLE = no;
        NET_ACT_SIMP = no;
        NET_ACT_SKBEDIT = no;
        NET_ACT_SKBMOD = no;
        NET_ACT_TUNNEL_KEY = no;
        NET_ACT_VLAN = no;
        NET_CLS_BASIC = no;
        NET_CLS_FLOW = no;
        NET_CLS_FLOWER = no;
        NET_CLS_FW = no;
        NET_CLS_MATCHALL = no;
        NET_CLS_ROUTE4 = no;
      }
      #SCH
      {
        NET_SCH_CAKE = no;
        NET_SCH_CBS = no;
        NET_SCH_CHOKE = no;
        NET_SCH_CODEL = no;
        NET_SCH_DRR = no;
        NET_SCH_DUALPI2 = no;
        NET_SCH_ETF = no;
        NET_SCH_ETS = no;
        NET_SCH_GRED = no;
        NET_SCH_HFSC = no;
        NET_SCH_HHF = no;
        NET_SCH_MQPRIO = no;
        NET_SCH_MULTIQ = no;
        NET_SCH_NETEM = no;
        NET_SCH_PIE = no;
        NET_SCH_PLUG = no;
        NET_SCH_PRIO = no;
        NET_SCH_RED = no;
        NET_SCH_SFB = no;
        NET_SCH_SKBPRIO = no;
        NET_SCH_TAPRIO = no;
        NET_SCH_TBF = no;
        NET_SCH_TEQL = no;
        NFT_OSF = no;
        NFT_XFRM = no;
      }
      #NETFILTER
      {
        BRIDGE_CFM = no;
        BRIDGE_EBT_802_3 = no;
        BRIDGE_EBT_AMONG = no;
        BRIDGE_EBT_ARP = no;
        BRIDGE_EBT_ARPREPLY = no;
        BRIDGE_EBT_DNAT = no;
        BRIDGE_EBT_IP = no;
        BRIDGE_EBT_IP6 = no;
        BRIDGE_EBT_LIMIT = no;
        BRIDGE_EBT_LOG = no;
        BRIDGE_EBT_MARK = no;
        BRIDGE_EBT_MARK_T = no;
        BRIDGE_EBT_NFLOG = no;
        BRIDGE_EBT_PKTTYPE = no;
        BRIDGE_EBT_REDIRECT = no;
        BRIDGE_EBT_SNAT = no;
        BRIDGE_EBT_STP = no;
        BRIDGE_EBT_VLAN = no;
        BRIDGE_MRP = no;
        IP_NF_MATCH_ECN = no;
        IP_NF_MATCH_TTL = no;
        NETFILTER_NETLINK_OSF = no;
        NETFILTER_XT_MATCH_CLUSTER = no;
        NETFILTER_XT_MATCH_CPU = no;
        NETFILTER_XT_MATCH_DCCP = no;
        NETFILTER_XT_MATCH_DEVGROUP = no;
        NETFILTER_XT_MATCH_DSCP = no;
        NETFILTER_XT_MATCH_ECN = no;
        NETFILTER_XT_MATCH_ESP = no;
        NETFILTER_XT_MATCH_HL = no;
        NETFILTER_XT_MATCH_IPCOMP = no;
        NETFILTER_XT_MATCH_L2TP = no;
        NETFILTER_XT_MATCH_LENGTH = no;
        NETFILTER_XT_MATCH_NFACCT = no;
        NETFILTER_XT_MATCH_OSF = no;
        NETFILTER_XT_MATCH_QUOTA = no;
        NETFILTER_XT_MATCH_RATEEST = no;
        NETFILTER_XT_MATCH_REALM = no;
        NETFILTER_XT_MATCH_SCTP = no;
        NETFILTER_XT_MATCH_STATISTIC = no;
        NETFILTER_XT_MATCH_STRING = no;
        NETFILTER_XT_MATCH_TIME = no;
        NETFILTER_XT_MATCH_U32 = no;
        NETFILTER_XT_TARGET_AUDIT = no;
        NETFILTER_XT_TARGET_HMARK = no;
        NETFILTER_XT_TARGET_IDLETIMER = no;
        NETFILTER_XT_TARGET_LED = no;
        NETFILTER_XT_TARGET_NETMAP = no;
        NETFILTER_XT_TARGET_RATEEST = no;
        NETFILTER_XT_TARGET_TEE = no;
        NF_CT_PROTO_SCTP = no;
        NF_CONNTRACK_AMANDA = no;
        NF_CONNTRACK_FTP = no;
        NF_CONNTRACK_H323 = no;
        NF_CONNTRACK_IRC = no;
        NF_CONNTRACK_NETBIOS_NS = no;
        NF_CONNTRACK_PPTP = no;
        NF_CONNTRACK_SANE = no;
        NF_CONNTRACK_SIP = no;
        NF_CONNTRACK_SNMP = no;
        NF_CONNTRACK_TFTP = no;
      }
      #PROTOCOLS
      {
        ARCNET = no;
        ATALK = no;
        ATM = no;
        BATMAN_ADV = no;
        CFG80211_CRDA_SUPPORT = no;
        CFG80211_DEBUGFS = no;
        CFG80211_WEXT = no;
        DIBS = no;
        EQUALIZER = no;
        GTP = no;
        HSR = no;
        INET_ESPINTCP = no;
        IP_PIMSM_V2 = no;
        IP_SCTP = no;
        IP_VS = no;
        LAPB = no;
        LLC2 = no;
        MACSEC = no;
        MPLS = no;
        MPTCP = no;
        NETCONSOLE = no;
        NETDEVSIM = no;
        NETLABEL = no;
        NETLINK_DIAG = no;
        NETWORK_SECMARK = no;
        NET_DSA = no;
        NET_EMATCH = no;
        NET_IFE = no;
        NET_KEY = no;
        NET_NSH = no;
        NET_PKTGEN = no;
        NET_SWITCHDEV = no;
        NET_TEAM = no;
        OPENVSWITCH = no;
        PFCP = no;
        PHONET = no;
        PPP = no;
        RDS = no;
        SLIP = no;
        TARGET_CORE = no;
        TLS_DEVICE = no;
        VLAN_8021Q = no;
        WAN = no;
        X25 = no;
        XFRM_IPTFS = no;
        XFRM_USER_COMPAT = no;
      }
      #IPV6
      {
        "6LOWPAN" = no;
        L2TP = no;
        IP6_NF_MATCH_AH = no;
        IP6_NF_MATCH_EUI64 = no;
        IP6_NF_MATCH_FRAG = no;
        IP6_NF_MATCH_HL = no;
        IP6_NF_MATCH_IPV6HEADER = no;
        IP6_NF_MATCH_MH = no;
        IP6_NF_MATCH_OPTS = no;
        IP6_NF_MATCH_RT = no;
        IP6_NF_MATCH_SRH = no;
        IP6_NF_TARGET_NPT = no;
        IP6_NF_TARGET_SYNPROXY = no;
        IPV6_MIP6 = no;
        IPV6_SIT = no;
        IPV6_VTI = no;
        NET_IPGRE_DEMUX = no;
        TIPC = no;
      }
    ];
  };
}
