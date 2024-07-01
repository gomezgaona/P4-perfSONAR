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

struct headers {
    ethernet_t   ethernet;
}

/*Define the custom headers below*/
struct digest_t {
    bit<48> srcAddr;
    bit<9> in_port;
}


struct metadata {
    digest_t mac_learn_digest;
}
