/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    


    action forward(macAddr_t dstAddr, egressSpec_t port) {
        standard_metadata.egress_spec = port;
        hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = dstAddr;
        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }

    action drop() {
       mark_to_drop(standard_metadata);
    }

    table forwarding {
        key = { 
            hdr.ipv4.dstAddr : exact;
        }
        actions = {
            forward;
            drop;
        }
        size = 1024;
        default_action = drop();
    }

    action compute_flow_id() {
        hash (
            meta.flow_id,
            HashAlgorithm.crc16,
            (bit<1>)0,
            {
                hdr.ipv4.srcAddr,
                hdr.ipv4.dstAddr,
                hdr.ipv4.protocol,
                hdr.tcp.srcPort,
                hdr.tcp.dstPort                
            },
            (bit<16>)65535
        );
    }

    register<bit<48>>(65536) last_timestamp_reg;



    apply {

        if(hdr.ipv4.isValid()) {
            forwarding.apply();
            if(hdr.tcp.isValid()) {
                compute_flow_id();

                bit<48> last_timestamp;
                last_timestamp_reg.read(last_timestamp, (bit<32>)meta.flow_id);
                if(last_timestamp == 0) {
                    last_timestamp_reg.write((bit<32>)meta.flow_id, standard_metadata.ingress_global_timestamp);
                }
                else if(standard_metadata.ingress_global_timestamp - last_timestamp > 1000000) {
                    clone_preserving_field_list(CloneType.I2E, 5, 0);
                    last_timestamp_reg.write((bit<32>)meta.flow_id, standard_metadata.ingress_global_timestamp);
                }    

            }
        }       
    }
}
