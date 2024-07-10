const bit<16> TYPE_IPV4 = 0x0800;
const bit<8> TYPE_TCP = 6;

/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;

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
    bit<32> src_ip;
    bit<32> dst_ip;
    bit<48> throughput;
}

struct metadata {
    @field_list(0)
    bit<16> flow_id;
    bit<32> src_ip;
    bit<32> dst_ip;
}

struct headers {
    ethernet_t          ethernet;
    ipv4_t              ipv4;
    tcp_t               tcp;
    report_t        report;
}   
