library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ALU is
    Port ( a1 : in STD_LOGIC_VECTOR (31 downto 0);
           a2 : in STD_LOGIC_VECTOR (31 downto 0);
           alu_control : in STD_LOGIC_VECTOR (3 downto 0);  
           ALU_result : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
    
    signal resultX : std_logic_vector(31 downto 0);
    
    
begin

    process(a1, a2, alu_control)
    begin
        
        case alu_control is
        
            when "0000" => -- Bitwise And
                resultX <= a1 and a2;
                
            when "0001" => -- Bitwise OR
                resultX <= a1 or a2;
                
            when "0010" => -- Addition
                resultX <= std_logic_vector(unsigned(a1) +  unsigned(a2));
            
            when "0110" => -- Subtraction
                resultX <= std_logic_vector(unsigned(a1) -  unsigned(a2));
            
            when "0111" => -- Set Less Than
                if ( a1 < a2 ) then
                    resultX <= x"00000001";
                else
                    resultX <= x"00000000";
                end if;
            
            when "1100" => -- Logical Nor
                resultX <= a1 nor a2;
                
            when others => null;  -- NOP
                resultX <= x"00000000";
                
        end case;
        
    end process;

    -- Concurrent Code
    ALU_result <= resultX;
    Zero <= '1' when resultX = x"00000000" else
            '0';

end Behavioral;
