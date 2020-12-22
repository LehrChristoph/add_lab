module MPSAT_unmapped_implementation (out, in1, in2);
    output out;
    input in1;
    input in2;
    assign out =  (in2 | out) & in1 | in2 & out;
endmodule

