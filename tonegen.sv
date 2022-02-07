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





















    // always_ff @(posedge clk or posedge reset) begin
    //     if (reset) begin 
    //         outFreq <= '0;
    //         count <= '0; 
    //     end
    //     else if (write) begin
    //         outFreq <= writedata;
    //         togCount <= (fclk/(2*outFreq));
    //     end

    //     count <= nextCount;
    // end

    // // // toggle speaker
    // // always_ff @(posedge clk) begin

    // //     if (outFreq != '0) begin
    // //         if (count == togCount) begin
    // //             spkr = ~spkr;
    // //             togCount <= nextToggle;
    // //         end
    // //     end

    // // end

    // always_comb begin
    //     if (outFreq != '0) begin 
    //         nextCount = count + 1;
    //     end
    //     else nextCount = '0;
    //     // nextToggle = count + (fclk/(2*outFreq));

    //     if (nextCount == fclk || write) nextCount = '0;

    //     togClk = |(count % togCount);
    // end

    
    // always_ff @(negedge togClk, posedge reset ) begin
    //     if (reset) spkr = 1'b0;
    //     else spkr = ~spkr;
    // end

