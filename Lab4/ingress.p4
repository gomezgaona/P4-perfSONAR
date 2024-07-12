/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
                    
    /************************************************************************
    ***********************FORWARDING ACTIONS AND TABLES*********************
    *************************************************************************/
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

    /************************************************************************
    ****************RTT COMPUTATION ACTIONS AND TABLES***********************
    *************************************************************************/
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

    action mark_SEQ() {
        meta.pkt_type = PKT_TYPE_SEQ;
    }

    action mark_ACK() {
        meta.pkt_type = PKT_TYPE_ACK;
    }

    table get_packet_type {
        key = {
            hdr.tcp.flags: ternary;
            hdr.ipv4.totalLen: range;
        }
        actions = {
            mark_SEQ;
            mark_ACK;
            drop;
        }
        default_action = mark_SEQ();
        const entries = {
            (TCP_FLAGS_S, _) : mark_SEQ();
            (TCP_FLAGS_S + TCP_FLAGS_A, _) : mark_ACK();
            (TCP_FLAGS_A, 0..80) : mark_ACK();
            (TCP_FLAGS_A + TCP_FLAGS_P, 0..80) : mark_ACK();
            (_,100..1600): mark_SEQ;
            (TCP_FLAGS_R,_): drop();
            (TCP_FLAGS_F,_): drop();            
        }
    }

    action compute_expected_ack() {
        meta.expected_ack = hdr.tcp.seqNo + ((bit<32>)(hdr.ipv4.totalLen - 
            (((bit<16>)hdr.ipv4.ihl + ((bit<16>)hdr.tcp.dataOffset)) * 16w4)));
        if(hdr.tcp.flags == TCP_FLAGS_S) {
            meta.expected_ack = meta.expected_ack + 1;
        }
    }

    action get_pkt_signature_SEQ() {
        hash (
            meta.pkt_signature,
            HashAlgorithm.crc32,
            (bit<1>)0,
            {
                hdr.ipv4.srcAddr,
                hdr.ipv4.dstAddr,
                hdr.tcp.srcPort,
                hdr.tcp.dstPort,
                meta.expected_ack              
            },
            (bit<32>)1048576
        );
    }

    action get_pkt_signature_ACK() {
        hash (
            meta.pkt_signature,
            HashAlgorithm.crc32,
            (bit<1>)0,
            {
                hdr.ipv4.dstAddr,
                hdr.ipv4.srcAddr,
                hdr.tcp.dstPort,
                hdr.tcp.srcPort,
                hdr.tcp.ackNo              
            },
            (bit<32>)1048576
        );
    }

    register<bit<32>>(1048576) last_timestamp_reg;

    /************************************************************************
    **************************INGRESS PIPELINE LOGIC*************************
    *************************************************************************/
    apply {
        if(hdr.ipv4.isValid()) {
            forwarding.apply();
            
            if(hdr.tcp.isValid()) {
                compute_flow_id();
                get_packet_type.apply();

                if(meta.pkt_type == PKT_TYPE_SEQ) {
                    compute_expected_ack();
                    get_pkt_signature_SEQ();
                    last_timestamp_reg.write((bit<32>)meta.pkt_signature,
                    (bit<32>)standard_metadata.ingress_global_timestamp);
                } else {
                    get_pkt_signature_ACK();
                    bit<32> extracted_ts;
                    last_timestamp_reg.read(extracted_ts, (bit<32>)meta.pkt_signature);
                    meta.rtt_sample = (bit<32>)standard_metadata.ingress_global_timestamp 
                        - extracted_ts;
                    clone_preserving_field_list(CloneType.I2E, 5, 0);
                }

            }
        }       
    }
}
