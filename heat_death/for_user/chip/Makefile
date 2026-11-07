IVERILOG ?= iverilog
VVP ?= vvp

sim: cells.v hd_top.v tb.v
	$(IVERILOG) -g2005 -o sim cells.v hd_top.v tb.v

# the netlist is large: Icarus simulates a few hundred cycles per second
run: sim
	$(VVP) -n sim +maxcycles=60000

status: sim
	$(VVP) -n sim +maxcycles=260000 +status=40000

clean:
	rm -f sim

.PHONY: run status clean
