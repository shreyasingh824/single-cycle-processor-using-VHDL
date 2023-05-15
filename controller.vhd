library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity control_fun is
Port (      
     
      opcode : in std_logic_vector(5 downto 0);
      destination_reg : out std_logic;
      jump : out std_logic;
      branch : out std_logic;
      read_mem : out std_logic;
      memtoreg : out std_logic;
      aluopcode : out std_logic_vector(1 downto 0);
       write_mem : out std_logic;
      alusource : out std_logic;
      write_reg : out std_logic
      


 );
end control_fun;

architecture Behavioral of control_fun is

begin
         process(opcode)
         begin
              write_reg <= '0';
              
              case opcode is 
               
                    when "000000" =>----R TYPE 
                                   
                                   destination_reg <= '1';
                                   jump <='0';
                                     branch <='0';
                                     read_mem <='0';
                                      memtoreg <='0';
                                      aluopcode <="10";
                                      write_mem <='0';
                                      alusource <= '0';
                                      write_reg <= '1' after 10 ns;
      
                    when "100011" =>----LOAD WORD 
                                   
                                   destination_reg <= '0';
                                   jump <='0';
                                     branch <='0';
                                     read_mem <='1';
                                      memtoreg <='1';
                                      aluopcode <="00";
                                      write_mem <='0';
                                      alusource <= '1';
                                      write_reg <= '1' after 10 ns;
      
                    when "101011" =>----STORE WORD 
                                   
                                   destination_reg <= 'X';
                                   jump <='0';
                                     branch <='0' after 2 ns;
                                     read_mem <='0';
                                     memtoreg <='X';
                                      aluopcode <="00";
                                      write_mem <='1';
                                      alusource <= '1';
                                      write_reg <= '0' after 10 ns;
                                      
                     when "000100" =>----BEQ WORD 
                                   
                                   destination_reg <= 'X';
                                   jump <='0';
                                     branch <='1' after 2 ns;
                                     read_mem <='0';
                                     memtoreg <='X';
                                      aluopcode <="01";
                                      write_mem <='0';
                                      alusource <= '0';
                                      write_reg <= '0' after 10 ns;
                    when "000010" =>----JUMP 
                                   
                                   destination_reg <= 'X';
                                   jump <='1';
                                     branch <='0';
                                     read_mem <='0';
                                     memtoreg <='X';
                                      aluopcode <="00";
                                      write_mem <='0';
                                      alusource <= '0';
                                      write_reg <= '0' after 10 ns;                                     
                                      
                       when others => null; 
                                   
                                   destination_reg <= '0';
                                   jump <='0';
                                     branch <='0';
                                     read_mem <='0';
                                     memtoreg <='0';
                                      aluopcode <="00";
                                      write_mem <='0';
                                      alusource <= '0';
                                      write_reg <= '0' after 10 ns;                                     
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                          end case;
                  end process;
                                                                     

end Behavioral;
