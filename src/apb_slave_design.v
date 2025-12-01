/*
module apb_slave #(
    parameter ADDR_WIDTH = 8,      // Address bus width
    parameter DATA_WIDTH = 32,     // Data bus width
    parameter MEM_DEPTH  = 256     // Memory depth (number of locations)
)(
    // APB Global Signals
    input  wire                    PCLK,       // Clock
    input  wire                    PRESETn,    // Active-low reset
    // APB Slave Signals
    input  wire [ADDR_WIDTH-1:0]   PADDR,      // Address
    input  wire                    PSEL,       // Slave select
    input  wire                    PENABLE,    // Enable
    input  wire                    PWRITE,     // Write control (1=Write, 0=Read)
    input  wire [DATA_WIDTH-1:0]   PWDATA,     // Write data
    input  wire [DATA_WIDTH/8-1:0] PSTRB,      // Write strobe (byte enables)
    output reg  [DATA_WIDTH-1:0]   PRDATA,     // Read data
    output wire                    PREADY,     // Ready signal
    output wire                    PSLVERR     // Error signal
);
 
    //==========================================================================
    // Local Parameters
    //==========================================================================
    localparam BYTE_WIDTH = 8;
    localparam NUM_BYTES  = DATA_WIDTH / BYTE_WIDTH;
    //==========================================================================
    // Internal Memory Declaration
    //==========================================================================
    reg [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];
    //==========================================================================
    // Internal Signals
    //==========================================================================
    wire transfer;          // Valid APB transfer
    wire write_enable;      // Write enable signal
    wire read_enable;       // Read enable signal
    wire addr_valid;        // Address within valid range
    integer i;              // Loop variable
    //==========================================================================
    // APB Transfer Detection
    //==========================================================================
    // Transfer occurs when slave is selected and enabled
    assign transfer = PSEL & PENABLE;
    // Write enable: transfer is happening and it's a write operation
    assign write_enable = transfer & PWRITE;
    // Read enable: transfer is happening and it's a read operation
    assign read_enable = transfer & ~PWRITE;
    // Check if address is within valid memory range
    assign addr_valid = (PADDR < MEM_DEPTH);
    //==========================================================================
    // APB Ready and Error Signals
    //==========================================================================
    // Always ready (single cycle access)
    // For multi-cycle access, implement wait states here
    assign PREADY = 1'b1;
    // Generate error if address is out of range during a valid transfer
    assign PSLVERR = transfer & ~addr_valid;
    //==========================================================================
    // Write Operation with Byte Strobes
    //==========================================================================
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            // Initialize memory to zero on reset
            for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                memory[i] <= {DATA_WIDTH{1'b0}};
            end
        end
        else begin
            if (write_enable && addr_valid) begin
                // Write data based on byte strobes
                for (i = 0; i < NUM_BYTES; i = i + 1) begin
                    if (PSTRB[i]) begin
                        memory[PADDR][i*BYTE_WIDTH +: BYTE_WIDTH] <= PWDATA[i*BYTE_WIDTH +: BYTE_WIDTH];
                    end
                end
            end
        end
    end
    //==========================================================================
    // Read Operation
    //==========================================================================
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            PRDATA <= {DATA_WIDTH{1'b0}};
        end
        else begin
            if (read_enable && addr_valid) begin
                PRDATA <= memory[PADDR];
            end
            else if (read_enable && ~addr_valid) begin
                // Return error pattern for out-of-range access
                PRDATA <= {DATA_WIDTH{1'b1}};  // All 1's for error
            end
            else begin
                PRDATA <= {DATA_WIDTH{1'b0}};
            end
        end
    end
   //==========================================================================
    // Optional: Memory Initialization for Simulation/Debug
    //==========================================================================
 //   `ifdef SIMULATION
 //   initial begin
        // Initialize some memory locations with test patterns
 //       memory[0] = 32'hDEADBEEF;
 //       memory[1] = 32'hCAFEBABE;
 //       memory[2] = 32'h12345678;
 //       memory[3] = 32'hABCDEF00;
        // Initialize rest to zero
 //       for (i = 4; i < MEM_DEPTH; i = i + 1) begin
 //           memory[i] = {DATA_WIDTH{1'b0}};
 //       end
 //   end
 //   `endif

endmodule
*/

module apb_slave (
    input         PCLK,      // Peripheral Clock
    input         PRESETn,   // Active Low Reset
    input         PSEL,      // Slave Select
    input         PENABLE,   // Enable Signal
    input         PWRITE,    // Write (1) / Read (0)
    input  [7:0]  PADDR,     // Address of Slave
    input  [7:0]  PWDATA,    // Write Data
    input  [3:0]  PSTRB,     // Pstrb
	  output reg [7:0] PRDATA, // Read Data
    output reg       PREADY,
    output reg       PSLVERR
);

  parameter N = 0;  // Number of wait states

  reg [7:0] mem [0:7]; // 8x8-bit memory
  reg [2:0] wait_counter;  // Counter for wait states
  reg transaction_active = 0;  //  indicate an active transaction

  always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      PREADY  <= 0;
      PSLVERR <= 0;
      PRDATA  <= 8'b0;
      transaction_active <= 0;
      wait_counter <= 0;

      for (integer i = 0; i < 8; i = i + 1) begin
        mem[i] <= 8'b0;
      end
    end
    else begin
      PSLVERR <= 0; // Default no error

      if (PSEL && PENABLE && !transaction_active) begin
        transaction_active <= 1; // Start kardenge transaction
        wait_counter <= 0;       //  counter==0
        PREADY <= 0;             // Enter wait state
      end

      if (transaction_active) begin
        if (wait_counter < N - 1) begin
          wait_counter <= wait_counter + 1; // Incrementing wait counter
        end
        else begin
          PREADY <= 1;  // Transaction complete hogya
          transaction_active <= 0; // Reset transaction flag

          if (PWRITE) begin
            if (PADDR == 8'h10 || PADDR == 8'h11) begin
              PSLVERR <= 1;  // Invalid address, assert error
            end
            else begin
              mem[PADDR[2:0]] <= PWDATA;  // Write operation
            end
          end
          else begin
            PRDATA <= mem[PADDR[2:0]]; // Read operation
          end
        end
      end
      else begin
        PREADY <= 0;
      end
    end
  end
endmodule
