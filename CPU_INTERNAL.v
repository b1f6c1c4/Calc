`ifndef __CPU_INTERNAL
`define __CPU_INTERNAL

`define CD_N 16
`define CD_0 {`CD_N{1'b0}}
`define CD_Z {`CD_N{1'bz}}

`define CO_N 4

`define CO_AD 4'h0
`define CO_SB 4'h1
`define CO_MU 4'h2
`define CO_DI 4'h3
`define CO_LP 4'h4
`define CO_RP 4'h5
`define CO_PS 4'h6
`define CO_NS 4'h7
`define CO_NO 4'hf

`endif
