library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity inst_mem is
    Port ( ReadAddr : in STD_LOGIC_VECTOR (31 downto 0);
           Instruction : out STD_LOGIC_VECTOR (31 downto 0));
end inst_mem;

architecture Behavioral of inst_mem is
                                 
        type RAM_64_x_8 is array(0 to 63) of std_logic_vector(7 downto 0);
       
        signal INSTRUCTION_MEMORY : RAM_64_x_8 := ( x"02", x"32", x"40", x"20",x"02", x"32", x"40", x"22",
                                    x"01", x"28", x"50", x"20",x"01", x"28", x"50", x"22", 
                                    x"01", x"49", x"40", x"2a",x"12", x"11", x"ff", x"fb",
                                    x"01", x"28", x"50", x"24",x"01", x"8b", x"68", x"25",
                                    x"01", x"28", x"50", x"20",x"01", x"49", x"40", x"2a",
                                    x"08", x"10", x"00", x"00",x"01", x"28", x"50", x"22",
                                    x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00");
                                                                
                                   
begin
      process(ReadAddr)
      begin
        Instruction <=INSTRUCTION_MEMORY(TO_INTEGER(unsigned(ReadAddr))) & INSTRUCTION_MEMORY((TO_INTEGER(unsigned(ReadAddr)) + 1)) & INSTRUCTION_MEMORY((TO_INTEGER(unsigned(ReadAddr)) + 2)) & INSTRUCTION_MEMORY((TO_INTEGER(unsigned(ReadAddr)) + 3));
    end process;
end Behavioral;
