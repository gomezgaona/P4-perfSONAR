const bit<16> TYPE_IPV4 = 0x0800;
const bit<8> TYPE_TCP = 6;

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;

typedef bit<5> tcp_flags_t;
const tcp_flags_t TCP_FLAGS_F = 1;
const tcp_flags_t TCP_FLAGS_S = 2;
const tcp_flags_t TCP_FLAGS_R = 4;
const tcp_flags_t TCP_FLAGS_P = 8;
const tcp_flags_t TCP_FLAGS_A = 16;

#define PKT_TYPE_SEQ true
#define PKT_TYPE_ACK false

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

header tcp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<4>  res;
    bit<3>  ecn;
    bit<5> flags;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

header report_t {
    bit<32> rtt;
}

struct metadata {
    @field_list(0)
    bit<32> rtt_sample;
    bit<16> flow_id;
    bool pkt_type;
    bit<32> expected_ack;
    bit<32> pkt_signature;
}

struct headers {
    ethernet_t          ethernet;
    ipv4_t              ipv4;
    tcp_t               tcp;
    report_t            report;
}   
