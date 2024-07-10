/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/
#define PKT_INSTANCE_TYPE_EGRESS_CLONE 2

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
     apply { 
          if(standard_metadata.instance_type != PKT_INSTANCE_TYPE_EGRESS_CLONE) {
               clone_preserving_field_list(CloneType.E2E, 8, 0);
          } else {
               //hdr.ipv4.totalLen = 6; // 14 eth 20 IPv4 5 queue
               //hdr.ethernet.setInvalid();
               hdr.ipv4.setInvalid();
               hdr.tcp.setInvalid();

               hdr.queue.setValid();
               hdr.queue.queue = (bit<48>)standard_metadata.enq_qdepth;
               truncate((bit<32>)20);
          }/*
          else {
               hdr.ipv4.totalLen = 14 + 20 + 6; // 14 eth 20 IPv4 5 queue
               hdr.tcp.setInvalid();
               hdr.queue.setValid();
               hdr.queue.queue = (bit<48>)standard_metadata.enq_qdepth;
               truncate((bit<32>)hdr.ipv4.totalLen);
          }
          */

     }
}
