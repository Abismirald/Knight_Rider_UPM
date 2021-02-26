library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ring_counter is
  Port(
     clk: in std_logic;
     reset: in std_logic;
     boton: in std_logic;
     leds: out std_logic_vector(7 downto 0)
  );
end ring_counter;

architecture Behavioral of ring_counter is
    --Constants
    constant Max_freqdiv: integer := 125000000/14; --125*10^6/14 (125 millones => 1 segundo; 14 veces por segundo) 
    
    --Signals
    signal enable           : std_logic;
    signal freqdiv          : integer range 0 to Max_freqdiv-1;
    signal enable_shiftreg   : std_logic;
    signal shift_reg: std_logic_vector(13 downto 0);
    
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
    
    enable_shiftreg <= '1' when (freqdiv = Max_freqdiv-1) else '0';
    
    -- Shift register
    shiftreg: process(clk, reset)
    begin
        if(reset = '1') then
           shift_reg <= "10000000000000";
        elsif(clk'event and clk='1' and enable_shiftreg = '1') then
            if(shift_reg = "00000000000001") then
                shift_reg <= "10000000000000";
            else 
                shift_reg <= '0' & shift_reg(13 downto 1); -- puede que lo este viendo al reves
            end if;
        end if;
    end process;
    
    
    --Decoder
    with shift_reg select
        leds <= "00000001" when "10000000000000",
                "00000010" when "01000000000000",
                "00000100" when "00100000000000",
                "00001000" when "00010000000000",
                "00010000" when "00001000000000",
                "00100000" when "00000100000000",
                "01000000" when "00000010000000",
                "10000000" when "00000001000000",
                "01000000" when "00000000100000",
                "00100000" when "00000000010000",
                "00010000" when "00000000001000",
                "00001000" when "00000000000100",
                "00000100" when "00000000000010",
                "00000010" when "00000000000001",
                "--------" when others;
    


end Behavioral;
