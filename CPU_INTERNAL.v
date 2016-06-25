localparam CD_N = 16;
localparam CD_0 = {CD_N{1'b0}};
localparam CD_Z = {CD_N{1'bz}};

localparam CO_N = 4;

localparam CO_AD = 4'h0;
localparam CO_SB = 4'h1;
localparam CO_MU = 4'h2;
localparam CO_DI = 4'h3;
localparam CO_LP = 4'h4;
localparam CO_RP = 4'h5;
localparam CO_PS = 4'h6;
localparam CO_NS = 4'h7;
localparam CO_OK = 4'he;
localparam CO_NO = 4'hf;
