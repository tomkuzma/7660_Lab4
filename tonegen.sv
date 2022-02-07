// tonegen.sv
// reads an Avalon-MM bus to toggle a speaker output at a given frequency
// Tom Kuzma
// Feb 4, 2022


module tonegen
    #( parameter logic [31:0] fclk ) // clock frequency, Hz
    (   input logic [31:0] writedata, // Avalon MM bus, data
        input logic write, // write enable
        output logic spkr, // output for audio
        input logic reset, clk ) ; // active high reset and clock

    logic [31:0] count, nextCount, freq;
    logic nextSpkr;

    // next states ff
    always_ff @(posedge clk or posedge reset) begin
        // reset
        if (reset) begin
            count <= '0;
            freq <= '0;
            spkr <= 1'b0;
        end
        // load next state
        else begin
            count <= nextCount;
            spkr <= nextSpkr;
            if (write) freq <= (2*writedata); // load in frequency from writedata
        end
    end

    // speaker logic 
    always_comb begin    
        nextCount = count + freq; // increment count
        nextSpkr = spkr;    // hold speaker logic

        // toggle speaker and reset count
        if (nextCount >= fclk) begin
            nextCount = '0;
            nextSpkr = ~spkr;
        end
        
    end

endmodule