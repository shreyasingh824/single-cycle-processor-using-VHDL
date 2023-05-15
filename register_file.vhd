library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REG_FILE is
    generic (
        S : integer := 32;   
        L : integer := 5      
    );

  Port ( 
    ReadRegister1 : in std_logic_vector(L-1 downto 0);
    ReadRegister2 : in std_logic_vector(L-1 downto 0);
    WriteRegister : in std_logic_vector(L-1 downto 0);
    WriteData     : in std_logic_vector(S-1 downto 0);
    RegWrite      : in std_logic;
    ReadData1     : out std_logic_vector(S-1 downto 0);
    pcin          : in std_logic_vector(S-1 downto 0);
    pcout         : out std_logic_vector(S-1 downto 0);
    clock         : std_logic;
    reset         : std_logic;
    ReadData2     : out std_logic_vector(S-1 downto 0)
  );
end REG_FILE;

architecture Behavioral of REG_FILE is

    type reg_file_type is array(0 to 2**L-1) of std_logic_vector(S-1 downto 0);
    
    signal array_reg : reg_file_type := (x"00000000", -- $zero 
                                         x"00000000", -- $at
                                         x"00000000", -- $v0
                                         x"00000000", -- $v1
                                         x"00000000", -- $a0
                                         x"00000000", -- $a1
                                         x"00000000", -- $a2
                                         x"00000000", -- $a3
                                         x"00001011", -- $t0
                                         x"00000001", -- $t1
                                         x"00000001", -- $t2
                                         x"00001100", -- $t3 
                                         x"00000011", -- $t4
                                         x"00000231", -- $t5                                         
                                         x"00000000", -- $t6
                                         x"00000000", -- $t7
                                         x"00000111", -- $s0
                                         x"00000110", -- $s1
                                         x"00000000", -- $s2
                                         x"00000000", -- $s3
                                         x"00000000", -- $s4
                                         x"00000000", -- $s5
                                         x"00000000", -- $s6
                                         x"00000000", -- $s7
                                         x"00000000", -- $t8
                                         x"00000000", -- $t9
                                         x"00000000", -- $k0  
                                         x"00000000", -- $k1  --pc
                                         x"00000000",  -- $gp
                                         x"00000000",  -- $sp                                         
                                         x"00000000",  -- $fp
                                         x"00000000"); -- $ra
                                     
begin
    
    process(clock, reset)    
    begin
        if(reset = '1') then
            array_reg(29) <= x"00000000";
        elsif(rising_edge(clock)) then
            array_reg(29) <= pcin;
            if(RegWrite = '1') then
                array_reg(TO_INTEGER(unsigned(WriteRegister))) <= WriteData;
            end if;
        end if;
    end process;
    

    ReadData1 <= array_reg(to_integer(unsigned(ReadRegister1)));

    ReadData2 <= array_reg(to_integer(unsigned(ReadRegister2)));
    pcout <= array_reg(29);
    

end Behavioral;
