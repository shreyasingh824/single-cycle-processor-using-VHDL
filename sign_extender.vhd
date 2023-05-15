library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity SIGN_EXTENDER is
 Port ( 
        sin_in:in std_logic_vector(15 downto 0) ;
        sin_out: out std_logic_vector(31 downto 0)
 
 );
end SIGN_EXTENDER;

architecture Behavioral of SIGN_EXTENDER is

begin
           
           sin_out <= x"0000" & sin_in when sin_in(15) = '0' else
                x"FFFF" & sin_in;

end Behavioral;
