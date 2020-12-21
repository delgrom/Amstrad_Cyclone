-----------------------------------------------------
--
--  Multicore 2 keyboard adapter by Victor Trucco
--
-----------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Keyboard is
port (
  Clk          : in std_logic;
  KbdInt       : in std_logic;
  KbdScanCode  : in std_logic_vector(7 downto 0);
  Keyboarddata : out std_logic_vector(10 downto 0);
  key_strobe   : out std_logic;
  key_code     : out std_logic_vector(7 downto 0);
  key_pressed  : out std_logic;
  key_extended : out std_logic;
  KEY_VIDEO    : buffer std_logic;
);
end Keyboard;

architecture Behavioral of Keyboard is

signal IsReleased : std_logic;

begin 

process(Clk)
begin
  if rising_edge(Clk) then
      
	key_strobe <= KbdInt;
    if KbdInt = '1' then
	 
			if KbdScanCode = "11110000" then IsReleased <= '1'; else IsReleased <= '0'; end if; 

			--[10] - toggles with every press/release, [9] - pressed, [8] - extended, [7:0] ps2 scan code
			Keyboarddata <= '1' & not IsReleased & '0' & KbdScanCode;
			key_pressed <= not IsReleased;
			key_code    <= KbdScanCode;
			if KbdScanCode = x"e0" 	    then key_extended <= '1'; else key_extended <= '0'; end if;
			if KbdScanCode = x"7e" and IsReleased = '1' then KEY_VIDEO <= not KEY_VIDEO; end if; --BLoq Despl						
	 
	 else
	 
			Keyboarddata <= (others=>'0');
    
	 end if;
 
  end if;
end process;

end Behavioral;


