library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity uptodown is
    Port (
        clk: in std_logic;
        reset: in std_logic;
        boton: in std_logic;
        leds: out std_logic_vector(7 downto 0)
    );
end uptodown;

architecture Behavioral of uptodown is
    
    --Constants
    constant Max_freqdiv: integer := 125000000/14; --125*10^6/14 (125 millones => 1 segundo; 14 veces por segundo)
    
    --Signals
    signal enable           : std_logic;
    signal freqdiv          : integer range 0 to Max_freqdiv-1;
    signal enable_counter   : std_logic;
    signal counter          : integer range 0 to 7;
    signal Up_or_Down     : std_logic; --0 up 1 down 
     
begin

    -- Start/reset control
    Control: process(clk,reset)
    begin
        if(reset = '1') then
            enable <= '0';
        elsif(clk'event and clk='1') then
            if(boton = '1') then
                enable <= '1';
             end if;
        end if;
    end process;

    -- Frequency divider (14 times per second)
    frequency_divider: process(clk, reset)
    begin
        if(reset='1') then
            freqdiv <= 0;
        elsif(clk'event and clk='1') then
            if(enable ='1') then
                if(freqdiv < Max_freqdiv -1) then
                    freqdiv <= freqdiv +1;
                else
                    freqdiv <= 0;    
                end if;
            end if;
        end if;  
    end process;
    
    enable_counter <= '1' when (freqdiv = Max_freqdiv-1) else '0';
    
    -- Counter (0 to 7)
    counter_0to7: process(clk, reset)
    begin
        if(reset= '1') then
            counter <= 0;
            Up_or_Down <= '0'; --Up
        elsif(clk'event and clk= '1')then
            if(enable='1' and enable_counter= '1') then
                if(Up_or_Down = '0') then
                    if(counter < 7) then
                        counter <= counter +1;
                    else
                        Up_or_Down <= '1'; --Down
                        counter <= 6;
                    end if;
                elsif(Up_or_Down='1') then
                    if(counter > 0) then
                        counter <= counter-1;
                    else
                        Up_or_Down <= '0';
                        counter <= 1;
                    end if;
                end if;
            end if;        
        end if;
    end process;
    
    -- Decoder
    with counter select
            leds <= "00000001" when 0,
                    "00000010" when 1,
                    "00000100" when 2,
                    "00001000" when 3,
                    "00010000" when 4,
                    "00100000" when 5,
                    "01000000" when 6,
                    "10000000" when 7,
                    "--------" when others;
                    
end Behavioral;
