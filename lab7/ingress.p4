/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    
    action drop() {
        mark_to_drop(standard_metadata);
    }
    
    action forward(egressSpec_t port) {
        standard_metadata.egress_spec = port;
    }

    action learn_mac(){
        meta.mac_learn_digest.srcAddr = hdr.ethernet.srcAddr;
        meta.mac_learn_digest.in_port = standard_metadata.ingress_port;
        digest(1,meta.mac_learn_digest);
    }
    
    table mac_learn {
        key = {
            hdr.ethernet.srcAddr: exact;
        }
        actions = {
            learn_mac;
            NoAction;
        }
        size = 32;
        default_action = learn_mac();
    }

    table forwarding {
        key = {
            hdr.ethernet.dstAddr:exact;
        }
        actions = {
            forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }
    
    apply {
        mac_learn.apply();
        forwarding.apply();
    }
}
