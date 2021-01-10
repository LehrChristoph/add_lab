module enable (en, ack_in, req_out, req_in, out_ack);
    output en;
    output ack_in;
    output req_out;
    input req_in;
    input out_ack;
    assign en =  req_out;
    assign ack_in =  en;
    assign req_out =  (~out_ack | req_out) & req_in | ~out_ack & req_out;
endmodule

