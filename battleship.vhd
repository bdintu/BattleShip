library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity BattleShip is
	generic (
		clk_cycle		: integer := 2000000;
		clk_cycle_10ms	: integer := 2000000/100
	);

	port (
		CLK		: in std_logic;

		L			: out std_logic_vector (7 downto 0);
		MN			: out std_logic_vector (7 downto 0);

		JOY_A		: in std_logic_vector (4 downto 0);
		STATE_A	: out std_logic_vector (1 downto 0);
		STATUS_A	: out std_logic_vector (3 downto 0);
		POSX_A	: out std_logic_vector (2 downto 0);
		POSY_A	: out std_logic_vector (2 downto 0);
		
		JOY_B		: in std_logic_vector (4 downto 0);
		STATE_B	: out std_logic_vector (1 downto 0);
		STATUS_B	: out std_logic_vector (3 downto 0);
		POSX_B	: out std_logic_vector (2 downto 0);
		POSY_B	: out std_logic_vector (2 downto 0)
	);
end BattleShip;

architecture Behavioral of BattleShip is
	type StateType is ( StartA, StartB, WinA);
	signal State : StateType;

	signal clk_10ms : std_logic;
	signal temp		: std_logic_vector (7 downto 0) := "00000001";

begin

	STATE_A <= "11";
	STATUS_A <= "1111";
	POSX_A <= "111";
	POSY_A <= "111";

	STATE_B <= "11";
	STATUS_B <= "1111";
	POSX_B <= "111";
	POSY_B <= "111";

	state_name : process (State) is
	begin
		case State is
			when StartA =>
				L <= "00000110";
				State <= StartB;
			when StartB =>
				L <= "00000110";
				State <= WinA;
			when others =>
				State <= StartA;
		end case;
	end process state_name;

	clkdiv_10ms : process (CLK) is
		variable count : integer range 0 to clk_cycle_10ms := 0;
	begin
		if (CLK'event and CLK='1') then
			count := count + 1;
			if (count = clk_cycle_10ms) then
				clk_10ms <= '1';
			else
				clk_10ms <= '0';
			end if;
		end if;
	end process clkdiv_10ms;

	send : process(clk_10ms) is
	begin
		if (clk_10ms'event and clk_10ms='1') then
			temp <= temp(6 downto 0) & temp(7);
			MN <= temp;
		end if;
	end process send;

end Behavioral;