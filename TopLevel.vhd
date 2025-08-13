library ieee;
use ieee.std_logic_1164.all;

entity TopLevel is
    generic(WIDTH : positive := 32);
    port(
        clk     : in  std_logic;

        switches: in  std_logic_vector(9 downto 0);
        buttons : in  std_logic_vector(1 downto 0);     --button 1 is rst, 0 is inport en
        leds    : out std_logic_vector(WIDTH-1 downto 0);
        led0     : out std_logic_vector(6 downto 0);
        led0_dp  : out std_logic;
        led1     : out std_logic_vector(6 downto 0);
        led1_dp  : out std_logic;
        led2     : out std_logic_vector(6 downto 0);
        led2_dp  : out std_logic;
        led3     : out std_logic_vector(6 downto 0);
        led3_dp  : out std_logic;
        led4     : out std_logic_vector(6 downto 0);
        led4_dp  : out std_logic;
        led5     : out std_logic_vector(6 downto 0);
        led5_dp  : out std_logic
    );
end TopLevel;

architecture CPU of TopLevel is

    -- Signals between Controller and Datapath
    signal PCWriteCond    : std_logic;
    signal PCWrite        : std_logic;
    signal IorD         : std_logic;
    signal MemRead      : std_logic;
    signal MemWrite     : std_logic;
    signal MemToReg     : std_logic;
    signal IRWrite      : std_logic;
    signal JumpAndLink  : std_logic;
    signal IsSigned     : std_logic;
    signal PCSource     : std_logic_vector(1 downto 0);
    signal ALUOp        : std_logic_vector(3 downto 0);
    signal ALUSrcB      : std_logic_vector(1 downto 0);
    signal ALUSrcA      : std_logic;
    signal RegWrite     : std_logic;
    signal RegDest       : std_logic;

    -- Signals from datapath to controller
    signal IR_InstBits  : std_logic_vector(5 downto 0);
    signal addr         : std_logic_vector(15 downto 0);
    signal IR16         : std_logic;

    signal led0_temp, led1_temp, led2_temp, led3_temp, led4_temp, led5_temp : std_logic_vector(3 downto 0);
    signal rst  : std_logic;

begin
    rst <= not buttons(1);
    
    -- Datapath instantiation
    datapath_inst : entity work.Datapath
        generic map(WIDTH => WIDTH)
        port map(
            -- Control signals
            PC_wrCond   => PCWriteCond,
            PC_wr       => PCWrite,
            IorD        => IorD,
            MemRead     => MemRead,
            MemWrite    => MemWrite,
            MemToReg    => MemToReg,
            IRWrite     => IRWrite,
            JumpAndLink => JumpAndLink,
            IsSigned    => IsSigned,
            PCSource    => PCSource,
            ALUOp       => ALUOp,
            ALUSrcB     => ALUSrcB,
            ALUSrcA     => ALUSrcA,
            RegWrite    => RegWrite,
            RegDst      => RegDest,

            -- I/O
            switches    => switches,
            buttons     => buttons,
            outportData => leds,
            clk         => clk,
            rst         => rst,

            -- Feedback to Controller
            IR_InstBits => IR_InstBits,
            addr        => addr,
            IR16        => IR16
        );

    -- Controller instantiation
    controller_inst : entity work.Controller
        port map(
            clk         => clk,
            rst         => rst,
            IR31_26     => IR_InstBits,
            IR16        => IR16,
            addr        => addr,

            -- Control outputs
            PCWriteCond   => PCWriteCond,
            PCWrite       => PCWrite,
            IorD        => IorD,
            MemRead     => MemRead,
            MemWrite    => MemWrite,
            MemToReg    => MemToReg,
            IRWrite     => IRWrite,
            JumpAndLink => JumpAndLink,
            IsSigned    => IsSigned,
            PCSource    => PCSource,
            ALUOp       => ALUOp,
            ALUSrcB     => ALUSrcB,
            ALUSrcA     => ALUSrcA,
            RegWrite    => RegWrite,
            RegDest      => RegDest
        );

        -- LEDS
        U_LED0: entity work.decoder7seg port map(input => led0_temp, output => led0);
        U_LED1: entity work.decoder7seg port map(input => led1_temp, output => led1);
        U_LED2: entity work.decoder7seg port map(input => led2_temp, output => led2);
        U_LED3: entity work.decoder7seg port map(input => led3_temp, output => led3);
        U_LED4: entity work.decoder7seg port map(input => led4_temp, output => led4);
        U_LED5: entity work.decoder7seg port map(input => led5_temp, output => led5);
        led0_dp <= '1';
        led1_dp <= '1';
        led2_dp <= '1';
        led3_dp <= '1';
        led4_dp <= '1';
        led5_dp <= '1';
end CPU;
