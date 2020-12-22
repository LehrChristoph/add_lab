module c_element (out1, in1, in2);
    output out1;
    input in1;
    input in2;
    assign out1 =  (in2 | out1) & in1 | in2 & out1;
endmodule

