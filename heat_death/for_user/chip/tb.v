`timescale 1ns/1ps
// Minimal testbench for the recovered netlist.
//   +maxcycles=<n>   stop after n clock cycles (default 60000)
//   +status=<cycle>  send one byte ('?') to the chip's UART at the given cycle
// UART: 8N1, 16 clock cycles per bit.  Characters received from the chip are
// written to stdout.  Simulation ends 400 cycles after the LED output rises.
module tb;
  reg clk = 1'b0;
  reg rst_n = 1'b0;
  reg rx = 1'b1;
  wire tx;
  wire led;

  hd_top dut (.clk(clk), .rst_n(rst_n), .uart_rx(rx), .uart_tx(tx), .led(led));

  always #5 clk = ~clk;

  integer maxcycles;
  integer status_cycle;
  integer cyc;
  integer led_cycle;

  initial begin
    if (!$value$plusargs("maxcycles=%d", maxcycles)) maxcycles = 60000;
    if (!$value$plusargs("status=%d", status_cycle)) status_cycle = -1;
    cyc = 0;
    led_cycle = -1;
    #103 rst_n = 1'b1;
  end

  task send_byte(input [7:0] b);
    integer i;
    begin
      @(posedge clk); #1 rx = 1'b0;
      repeat (16) @(posedge clk);
      for (i = 0; i < 8; i = i + 1) begin
        #1 rx = b[i];
        repeat (16) @(posedge clk);
      end
      #1 rx = 1'b1;
      repeat (16) @(posedge clk);
    end
  endtask

  initial begin
    if (status_cycle >= 0) begin
      wait (cyc == status_cycle);
      send_byte(8'h3F);
    end
  end

  // UART receiver (chip -> host)
  reg [1:0] st = 2'd0;
  integer cnt = 0;
  integer bits = 0;
  reg [7:0] val = 8'd0;
  reg prev = 1'b1;

  always @(posedge clk) begin
    cyc <= cyc + 1;
    case (st)
      2'd0: if (prev == 1'b1 && tx == 1'b0) begin st <= 2'd1; cnt <= 0; end
      2'd1: begin
        cnt <= cnt + 1;
        if (cnt == 7) begin
          if (tx == 1'b0) begin st <= 2'd2; cnt <= 0; bits <= 0; val <= 8'd0; end
          else st <= 2'd0;
        end
      end
      2'd2: begin
        cnt <= cnt + 1;
        if (cnt == 15) begin
          cnt <= 0;
          val[bits] <= tx;
          bits <= bits + 1;
          if (bits == 7) st <= 2'd3;
        end
      end
      2'd3: begin
        cnt <= cnt + 1;
        if (cnt == 15) begin
          st <= 2'd0;
          $write("%c", val);
          $fflush;
        end
      end
    endcase
    prev <= tx;
    if (led == 1'b1 && led_cycle < 0) led_cycle <= cyc;
    if (led_cycle >= 0 && cyc > led_cycle + 400) begin
      $display("\n[tb] led asserted at cycle %0d, stopping", led_cycle);
      $finish;
    end
    if (cyc >= maxcycles) begin
      $display("\n[tb] %0d cycles simulated, chip still running", cyc);
      $finish;
    end
  end
endmodule
