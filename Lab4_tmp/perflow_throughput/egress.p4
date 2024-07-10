/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/
#define PKT_INSTANCE_TYPE_IGRESS_CLONE 1

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {

    register<bit<48>>(65536) per_flow_tput_reg;
    bit<48> per_flow_tput;

     action get_and_reset_flow_tput() {
        per_flow_tput_reg.read(per_flow_tput, (bit<32>) meta.flow_id);
        per_flow_tput_reg.write((bit<32>) meta.flow_id, 0);
     }
     action count_flow_bytes() {
        per_flow_tput_reg.read(per_flow_tput, (bit<32>) meta.flow_id);
        per_flow_tput = per_flow_tput + ((bit<48>)hdr.ipv4.totalLen << 3);
        per_flow_tput_reg.write((bit<32>) meta.flow_id, per_flow_tput);
     }

     apply { 
          if(standard_metadata.instance_type == PKT_INSTANCE_TYPE_IGRESS_CLONE) {
               
               get_and_reset_flow_tput();

               hdr.ethernet.etherType = 0x1234;

               hdr.report.setValid();
               hdr.report.throughput = (bit<48>)per_flow_tput;
               hdr.report.src_ip = hdr.ipv4.srcAddr;
               hdr.report.dst_ip = hdr.ipv4.dstAddr;
               
               hdr.ipv4.setInvalid();
               hdr.tcp.setInvalid();
               
               truncate((bit<32>)28);
          } else {
               count_flow_bytes();
          }

     }
}
