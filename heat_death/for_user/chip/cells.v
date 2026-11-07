// NS18 standard-cell library -- functional (zero delay) simulation models

`timescale 1ns/1ps

module NS18_INV (output Y, input A);
  assign Y = ~A;
endmodule

module NS18_BUF (output Y, input A);
  assign Y = A;
endmodule

module NS18_NAND2 (output Y, input A, input B);
  assign Y = ~(A & B);
endmodule

module NS18_NAND3 (output Y, input A, input B, input C);
  assign Y = ~(A & B & C);
endmodule

module NS18_NOR2 (output Y, input A, input B);
  assign Y = ~(A | B);
endmodule

module NS18_NOR3 (output Y, input A, input B, input C);
  assign Y = ~(A | B | C);
endmodule

module NS18_AND2 (output Y, input A, input B);
  assign Y = A & B;
endmodule

module NS18_AND3 (output Y, input A, input B, input C);
  assign Y = A & B & C;
endmodule

module NS18_OR2 (output Y, input A, input B);
  assign Y = A | B;
endmodule

module NS18_OR3 (output Y, input A, input B, input C);
  assign Y = A | B | C;
endmodule

module NS18_XOR2 (output Y, input A, input B);
  assign Y = A ^ B;
endmodule

module NS18_XNOR2 (output Y, input A, input B);
  assign Y = ~(A ^ B);
endmodule

module NS18_AOI21 (output Y, input A1, input A2, input B);
  assign Y = ~((A1 & A2) | B);
endmodule

module NS18_OAI21 (output Y, input A1, input A2, input B);
  assign Y = ~((A1 | A2) & B);
endmodule

module NS18_AOI22 (output Y, input A1, input A2, input B1, input B2);
  assign Y = ~((A1 & A2) | (B1 & B2));
endmodule

module NS18_OAI22 (output Y, input A1, input A2, input B1, input B2);
  assign Y = ~((A1 | A2) & (B1 | B2));
endmodule

module NS18_MUX2 (output Y, input A, input B, input S);
  assign Y = S ? B : A;
endmodule

module NS18_TIEH (output Y);
  assign Y = 1'b1;
endmodule

module NS18_TIEL (output Y);
  assign Y = 1'b0;
endmodule

module NS18_DFFR (output reg Q, output QN, input CK, input RN, input D);
  assign QN = ~Q;
  always @(posedge CK or negedge RN)
    if (!RN) Q <= 1'b0; else Q <= D;
endmodule

module NS18_DFFS (output reg Q, output QN, input CK, input SN, input D);
  assign QN = ~Q;
  always @(posedge CK or negedge SN)
    if (!SN) Q <= 1'b1; else Q <= D;
endmodule
