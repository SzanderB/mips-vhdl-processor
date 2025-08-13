library ieee;
use ieee.std_logic_1164.all;

entity TopLevel_tb is
end TopLevel_tb;

architecture TB of TopLevel_tb is
    signal clk     : std_logic;
    signal rst     : std_logic;

    signal switches: std_logic_vector(9 downto 0);
    signal buttons : std_logic_vector(1 downto 0);
    signal leds    : std_logic_vector(31 downto 0);

    -- didnt use but needed them
    signal led0, led1, led2, led3, led4, led5 : std_logic_vector(6 downto 0);
    signal led0_dp, led1_dp, led2_dp, led3_dp, led4_dp, led5_dp : std_logic;

begin
    UUT: entity work.Toplevel
    generic map(WIDTH => 32)
    port map(
        clk => clk,

        switches => switches,
        buttons  => buttons,
        leds     => leds,
        led0     => led0,
        led0_dp  => led0_dp,
        led1     => led1,
        led1_dp  => led1_dp,
        led2     => led2,
        led2_dp  => led2_dp,
        led3     => led3,
        led3_dp  => led3_dp,
        led4     => led4,
        led4_dp  => led4_dp,
        led5     => led5,
        led5_dp  => led5_dp
    );

    clk_process : process
    begin
        while now < 10 us loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    stimmy: process
    begin
        buttons(1) <= '0';       -- reset
        wait for 10 ns;
        buttons(1) <= '1';       -- no reset
        wait for 10 ns;

        switches(8 downto 0) <= "111111111";    --load inport 1
        switches(9)          <= '0';
        buttons(0)            <= '0';  -- Assert load
        wait for 5 ns;
        buttons(0)            <= '1';  -- Deassert
        wait for 10 ns;

        wait for 10 us;

        report "Simulation Finished!.";
        wait;
    end process;
end TB;