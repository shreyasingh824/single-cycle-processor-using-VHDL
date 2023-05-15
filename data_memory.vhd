library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity DATA_MEM is
 Port (    Addr : in STD_LOGIC_VECTOR (31 downto 0);
           Write_Data : in STD_LOGIC_VECTOR (31 downto 0);
           Mem_Read : in STD_LOGIC;
           Mem_Write : in STD_LOGIC;
           Read_Data : out STD_LOGIC_VECTOR (31 downto 0)
           );
end DATA_MEM;

architecture Behavioral of DATA_MEM is
type DM_64_x_8 is array(0 to 63) of std_logic_vector(7 downto 0);
      
          signal DATA_MEMORY : DM_64_x_8 := ( x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00", 
                                    x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00",
                                    x"00", x"00", x"00", x"00",x"00", x"00", x"00", x"00");

begin
  
    process(Mem_Write, Mem_Read) 
    begin
        if ( Mem_Write = '1') then
            DATA_MEMORY(TO_INTEGER(unsigned(Addr)))<= Write_Data(7 downto 0);
            DATA_MEMORY(TO_INTEGER(unsigned(Addr)) + 1) <= Write_Data(15 downto 8);
            DATA_MEMORY(TO_INTEGER(unsigned(Addr)) + 2) <= Write_Data(23 downto 16);
            DATA_MEMORY(TO_INTEGER(unsigned(Addr)) + 3) <= Write_Data(31 downto 24);
        end if;
        
        if ( Mem_Read = '1') then
            Read_Data <= DATA_MEMORY(TO_INTEGER(unsigned(Addr))) & DATA_MEMORY(TO_INTEGER(unsigned(Addr)) + 1) & DATA_MEMORY(TO_INTEGER(unsigned(Addr)) + 2) & DATA_MEMORY(TO_INTEGER(unsigned(Addr)) + 3);
        end if;
    end process;    

end Behavioral;
