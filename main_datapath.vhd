library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;



entity MAIN_DATAPATH is
 Port ( 
           clock : in STD_LOGIC;
           reset : in STD_LOGIC
 );
end MAIN_DATAPATH;

architecture Behavioral of MAIN_DATAPATH is


          component SIGN_EXTENDER is
         Port ( 
                 sin_in:in std_logic_vector(15 downto 0) ;
                 sin_out: out std_logic_vector(31 downto 0)
          );
        end component;
        
        
           component REG_FILE is
    generic (
        S : integer := 32;    -- 32 Bit Registers Size
        L : integer := 5      -- 5 Bits to Address these registers
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
   
   
   
     end component;
        
        
        component DATA_MEM is
           Port (    Addr : in STD_LOGIC_VECTOR (31 downto 0);
           Write_Data : in STD_LOGIC_VECTOR (31 downto 0);
           Mem_Read : in STD_LOGIC;
           Mem_Write : in STD_LOGIC;
           Read_Data : out STD_LOGIC_VECTOR (31 downto 0) );
         end component;
         
         
         component ALU is
          Port ( a1 : in STD_LOGIC_VECTOR (31 downto 0);
           a2 : in STD_LOGIC_VECTOR (31 downto 0);
           alu_control : in STD_LOGIC_VECTOR (3 downto 0);  -- !6 Different Operation
           ALU_result : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC);
          end component;
          component ALU_CONTROLLER is
          port (

           funct : in STD_LOGIC_VECTOR (5 downto 0);
           AluOp : in STD_LOGIC_VECTOR(1 downto 0);
           Oprtn : out STD_LOGIC_VECTOR (3 downto 0)
           );
           end component;
           
           
           


    component MUX is
        Generic (
            N: integer := 32
        );
        Port (  mux_in0: in std_logic_vector(N-1 downto 0);
                mux_in1: in std_logic_vector(N-1 downto 0);
                mux_ctl: in std_logic; -- Control Input
                mux_out: out std_logic_vector(N-1 downto 0)  
        );
        end component;

     
     component control_fun is
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
     end component;
component inst_mem is
      Port ( ReadAddr : in std_logic_vector (31 downto 0 );
             Instruction : out std_logic_vector (31 downto 0) 
             );
             
             
end component;
signal pc : std_logic_vector(31 downto 0) :=   x"00000000";
  
signal instruction : std_logic_vector(31 downto 0);
 signal regdst : std_logic;
 signal JUMP : std_logic;
 signal BRANCH : std_logic;
 signal MEMREAD : std_logic;
 signal MEMTOREG : std_logic;
 signal ALUOP : std_logic_vector(1 downto 0);
 signal MEMWRITE : std_logic;
 signal ALUSRC : std_logic;
 signal REGWRITE : std_logic;
 signal readdata1 : std_logic_vector(31 downto 0);
 signal readdata2 : std_logic_vector(31 downto 0);
 signal MULTIPLEXER1_OUT : std_logic_vector(4 downto 0);
 signal MULTIPLEXER5_OUT : std_logic_vector(31 downto 0);
 signal MULTIPLEXER3_OUT : std_logic_vector(31 downto 0);
 signal MULTIPLEXER2_OUT : std_logic_vector(31 downto 0);
 signal SIGN_EXTENDED_DATA : std_logic_vector(31 downto 0);
 signal operation : std_logic_vector(3 downto 0);
 signal aluresult1 : std_logic_vector(31 downto 0);
 signal zero : std_logic;
 signal memory_readdata : std_logic_vector(31 downto 0);
 signal pc_next : std_logic_vector(31 downto 0);
 signal shSIGN_EXTENDED_DATA : std_logic_vector(31 downto 0);
 signal FINAL_addr : std_logic_vector(31 downto 0);
 signal MULTIPLEXER4_OUT_CTRL : std_logic;
 signal MULTIPLEXER4_OUT : std_logic_vector(31 downto 0);
 signal jump_addr : std_logic_vector(31 downto 0);
  
begin


    

        INSTRUCTION_MEMORY : inst_mem port map (
                         ReadAddr => pc,
                         Instruction => instruction
                         
                         );
                         
                         
       CONTROLLER : control_fun port map(
                         opcode =>instruction(31 downto 26),
                         destination_reg =>regdst,
                         jump =>JUMP,
                         branch=>BRANCH,
                         read_mem =>MEMREAD,
                         memtoreg =>MEMTOREG,
                         aluopcode =>ALUOP,
                         write_mem =>MEMWRITE,
                        alusource =>ALUSRC,
                         write_reg=>REGWRITE
                         );
                         
        MULTIPLEXER1 : MUX generic map ( N => 5 ) port map (
        mux_in0 => instruction(20 downto 16),
        mux_in1 => instruction(15 downto 11),
        mux_ctl => regdst,
        mux_out => MULTIPLEXER1_OUT 
         ); 
         
          REGISTER_DATA : REG_FILE port map (
                 ReadRegister1 =>instruction(25 downto 21),
                 ReadRegister2=>instruction(20 downto 16),
                 WriteRegister =>MULTIPLEXER1_OUT ,
                 WriteData => MULTIPLEXER3_OUT,
                 RegWrite=> REGWRITE,
                 ReadData1=> readdata1,
                 ReadData2=> readdata2,
                
                 clock=>clock,
                 reset=>reset,
                  pcin=>MULTIPLEXER5_OUT,
                 pcout=>pc
                 
                 
                 
                 );
         
         
       SIGN_EXTEN : SIGN_EXTENDER port map (
             sin_in => instruction(15 downto 0),
             sin_out =>SIGN_EXTENDED_DATA
             );
             
             
             
        MULTIPLEXER2 : MUX generic map ( N => 32 ) port map (
        mux_in0 => readdata2,
        mux_in1 => SIGN_EXTENDED_DATA,
        mux_ctl => ALUSRC,
        mux_out => MULTIPLEXER2_OUT
    );
             
        
         ALU_CONTROL : ALU_CONTROLLER port map (
                 
           funct =>  instruction(5 downto 0),
           AluOp =>ALUOP,
           Oprtn =>operation
           );
           
           
         Ist_ALU : ALU port map (
        a1 => readdata1,
        a2 => MULTIPLEXER2_OUT,
        alu_control => operation,
        ALU_result => aluresult1,
        Zero => zero
        );

        DATA_MEMORY : DATA_MEM port map(
          Addr =>aluresult1,
          Write_Data=>readdata2,
          Mem_Read=>MEMREAD,
          Mem_Write =>MEMWRITE,
          Read_Data =>memory_readdata);
          
    MULTIPLEXER3 : MUX generic map ( N => 32 ) port map (
        mux_in0 => aluresult1,
        mux_in1 => memory_readdata,
        mux_ctl => MEMTOREG,
        mux_out => MULTIPLEXER3_OUT
    );
    pc_next <= std_logic_vector(unsigned(pc) + 4);             
    shSIGN_EXTENDED_DATA <= std_logic_vector(shift_left(unsigned(SIGN_EXTENDED_DATA), 2));
    FINAL_addr <= std_logic_vector(unsigned(pc_next) + unsigned(shSIGN_EXTENDED_DATA));
    MULTIPLEXER4_OUT_CTRL <= branch and zero;
    
    MULTIPLEXER4: MUX generic map ( N => 32 ) port map (
        mux_in0 => pc_next,
        mux_in1 => FINAL_addr,
        mux_ctl => MULTIPLEXER4_OUT_CTRL,
        mux_out => MULTIPLEXER4_OUT
        );
      
          
  jump_addr <= std_logic_vector(shift_left(unsigned("00" & instruction(25 downto 0)),2)) & pc_next(31 downto 28);        
          
        MULTIPLEXER5 : MUX generic map ( N => 32 ) port map (
        mux_in0 =>MULTIPLEXER4_OUT,
        mux_in1 => jump_addr,
        mux_ctl => JUMP,
        mux_out => MULTIPLEXER5_OUT
        ); 


















