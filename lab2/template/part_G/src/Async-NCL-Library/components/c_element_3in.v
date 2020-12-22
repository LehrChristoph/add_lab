module c_element_3in (out1, in1, in2, in3);
    output out1;
    input in1;
    input in2;
    input in3;
    assign out1 =  (in1 | in2 | in3) & out1 | in1 & in2 & in3;
endmodule