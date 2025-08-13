library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	generic (WIDTH : positive := 32);
	port (
		input1 		: in  std_logic_vector(WIDTH-1 downto 0);
		input2 		: in  std_logic_vector(WIDTH-1 downto 0);
		OPSelect	: in  std_logic_vector(4 downto 0);
		IRBits		: in  std_logic_vector(4 downto 0);
		output 		: out std_logic_vector(WIDTH-1 downto 0);
		outputHigh	: out std_logic_vector(WIDTH-1 downto 0);
		branched	: out std_logic
	);
end alu;

architecture alu_arch of alu is
--signals or variables

	constant ALU_AND	: std_logic_vector(4 downto 0) := "00000";
	constant ALU_OR		: std_logic_vector(4 downto 0) := "00001";
	constant ALU_XOR	: std_logic_vector(4 downto 0) := "00010";
	constant ALU_ADD	: std_logic_vector(4 downto 0) := "00011";
	constant ALU_SUB	: std_logic_vector(4 downto 0) := "00100";
	constant ALU_MULT_S	: std_logic_vector(4 downto 0) := "00101";
	constant ALU_MULT_U	: std_logic_vector(4 downto 0) := "00110";
	constant ALU_SRL	: std_logic_vector(4 downto 0) := "00111";
	constant ALU_SRA	: std_logic_vector(4 downto 0) := "01000";
	constant ALU_SLL	: std_logic_vector(4 downto 0) := "01001";
	constant ALU_SLT_S	: std_logic_vector(4 downto 0) := "01010";
	constant ALU_SLT_U	: std_logic_vector(4 downto 0) := "01011";
	constant ALU_BEQ	: std_logic_vector(4 downto 0) := "01100";
	constant ALU_BNE	: std_logic_vector(4 downto 0) := "01101";
	constant ALU_BGE	: std_logic_vector(4 downto 0) := "01110";
	constant ALU_BGT	: std_logic_vector(4 downto 0) := "01111";
	constant ALU_BLE	: std_logic_vector(4 downto 0) := "10000";
	constant ALU_BLT	: std_logic_vector(4 downto 0) := "10001";

begin
	process(input1, input2, OPSelect, IRBits)

	variable temp : std_logic_vector(WIDTH downto 0)			:= (others => '0');
	variable temp_mul : std_logic_vector(WIDTH*2-1 downto 0)	:= (others => '0');

	begin
		branched <= '0';
		outputHigh <= (others => '0');

	case OPSelect is
		when ALU_AND	=>							-- Bitwise AND
			output <= input1 and input2;
		when ALU_OR		=>							-- Bitwise OR
			output <= input1 or input2;
		when ALU_XOR	=>							-- Bitwise XOR
			output <= input1 xor input2;
		when ALU_ADD	=>							-- Add, overflow goes to outputHigh
			temp := std_logic_vector(resize(unsigned(input1), WIDTH+1) + resize(unsigned(input2), WIDTH+1));
			outputHigh(0) <= temp(WIDTH);
			outputHigh(31 downto 1) <= (others => '0');
			output <= temp(WIDTH-1 downto 0);
		when ALU_SUB	=>																			--sub (NOT SURE IF YOU HAVE OVERFLOW OR NEGATIVE NUMBERS)
			output <= std_logic_vector(unsigned(input1) - unsigned(input2));
		when ALU_MULT_S =>																			-- multiply SIGNED
			temp_mul := std_logic_vector(signed(input1) * signed(input2));
			outputHigh <= temp_mul(63 downto 32);
			output <= temp_mul(31 downto 0);
		when ALU_MULT_U =>																			-- multiply UNSIGNED
			temp_mul := std_logic_vector(unsigned(input1) * unsigned(input2));
			outputHigh <= temp_mul(63 downto 32);
			output <= temp_mul(31 downto 0);
		when ALU_SRL 	=>																			-- shift right LOGICAL
			output <= std_logic_vector(shift_right(unsigned(input2), to_integer(unsigned(IRBits))));
		when ALU_SRA 	=>																			-- shift right ARITHMETIC
			-- shift
			--temp(31 downto 0) := std_logic_vector(shift_right(signed(input2), to_integer(unsigned(IRBits))));
			-- extend the sign bit
			--temp(31 downto 32 - to_integer(unsigned(IRBits))) := (others => input1(31));
			output <= std_logic_vector(shift_right(signed(input2), to_integer(unsigned(IRBits))));
		when ALU_SLL 	=>																			-- shift left
			output <= std_logic_vector(shift_left(unsigned(input2), to_integer(unsigned(IRBits))));
		when ALU_SLT_S 	=>																			-- SIGNED Set if less than
			if(signed(input1) < signed(input2)) then
				output <= "00000000000000000000000000000001";
			else
				output <= (others => '0');
			end if;
		when ALU_SLT_U	=>																			-- UNSIGNED Set if less than
			if(unsigned(input1) < unsigned(input2)) then
				output <= "00000000000000000000000000000001";
			else
				output <= (others => '0');
			end if;
		when ALU_BEQ 	=>																			-- Compare equal, branch
			output <= std_logic_vector(unsigned(input1) + unsigned(input2));
			if(unsigned(input1) = unsigned(input2)) then
				branched <= '1';
			else
				branched <= '0';
			end if;
		when ALU_BNE	=> 																			-- Compare not equal, branch
			output <= std_logic_vector(unsigned(input1) + unsigned(input2));
			if(unsigned(input1) /= unsigned(input2)) then
				branched <= '1';
			else
				branched <= '0';
			end if;
		when ALU_BGE	=>																			-- compare greater equal than 0, branch
			output <= std_logic_vector(unsigned(input1) + unsigned(input2));

			if(unsigned(input1) >= 0) then
				branched <= '1';
			else
				branched <= '0';
			end if;
		when ALU_BGT	=>																			-- compare greater than 0, branch
			output <= std_logic_vector(unsigned(input1) + unsigned(input2));
			if(unsigned(input1) > 0) then
				branched <= '1';
			else
				branched <= '0';
			end if;
		when ALU_BLE	=>																			-- compare less equal than 0, branch
			output <= std_logic_vector(unsigned(input1) + unsigned(input2));
			if(unsigned(input1) <= 0) then
				branched <= '1';
			else
				branched <= '0';
			end if;
		when ALU_BLT	=>																			-- compare less than 0, branch
			output <= std_logic_vector(unsigned(input1) + unsigned(input2));
			if(unsigned(input1) < 0) then
				branched <= '1';
			else
				branched <= '0';
			end if;
		when others =>
			output <= input1;
	end case;

	end process;
end alu_arch;