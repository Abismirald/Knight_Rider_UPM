library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shiftregister is
    Port (
        clk: in std_logic;
        reset: in std_logic;
        boton: in std_logic;
        leds: out std_logic_vector(7 downto 0)
    );
end shiftregister;

architecture Behavioral of shiftregister is
    
    --Constants
    constant Max_freqdiv: integer := 125000000/14; --125*10^6/14 (125 millones => 1 segundo; 14 veces por segundo)
    
    --Signals
    signal enable           : std_logic;
    signal freqdiv          : integer range 0 to Max_freqdiv-1;
    signal enable_reg       : std_logic;
    signal shift_reg        : std_logic_vector(7 downto 0);
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
    
    enable_reg <= '1' when (freqdiv = Max_freqdiv-1) else '0';
    
    --Shift Register
    shiftreg: process(clk, reset)
    begin
        if(reset = '1') then
           shift_reg <= "10000000";
           Up_or_Down <= '0'; --Up
        elsif(clk'event and clk='1' and enable_reg = '1') then
            if(Up_or_Down = '0') then    
                if(shift_reg = "00000001") then
                    shift_reg <= "00000010";
                    Up_or_Down <= '1'; --Down
                else
                    shift_reg <=  '0' & shift_reg(7 downto 1); --1 hacia la derecha
                end if;
            elsif(Up_or_Down = '1') then
                if(shift_reg = "10000000") then
                    shift_reg <= "01000000";
                    Up_or_Down <= '0'; --Up
                else
                shift_reg <= shift_reg(6 downto 0) & '0'; -- 1 hacia la izquierda
                end if;
            end if;
        end if;
    end process;
    
    leds <= shift_reg; --No necesito decoder
     
end Behavioral;
