


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ALU_CONTROLLER is
port (

           funct : in STD_LOGIC_VECTOR (5 downto 0);
           AluOp : in STD_LOGIC_VECTOR(1 downto 0);
           Oprtn : out STD_LOGIC_VECTOR (3 downto 0)


 );
end ALU_CONTROLLER;

architecture Behavioral of ALU_CONTROLLER is

begin
    Oprtn(3) <= '0';
    Oprtn(2) <= AluOp(0) or (AluOp(1) and funct(1));
    Oprtn(1) <= not AluOp(1) or not funct(2);
    Oprtn(0) <= (funct(3) or funct(0)) and AluOp(1);

end Behavioral;
