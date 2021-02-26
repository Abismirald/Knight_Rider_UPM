library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_weblab is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        buttons  : in  std_logic_vector(3 downto 0);
        switches : in  std_logic_vector(7 downto 0);
        leds     : out std_logic_vector(7 downto 0);
        segments : out std_logic_vector(7 downto 0);
        selector : out std_logic_vector(3 downto 0)
    );
end top_weblab;

architecture wrapper of top_weblab is

begin

    rider_ii: entity work.ring_counter
        port map (
        clk => clk,
        reset => reset,
        boton => buttons(0),
        leds => leds
    );

    segments <= (others => '0');
    selector <= (others => '0');
    
end wrapper;
