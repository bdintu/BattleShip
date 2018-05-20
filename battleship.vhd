library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity BattleShip is
	generic (
		clk_cycle		: integer := 25000000;
		clk_cycle_10ms	: integer := 25000000/100
	);

	port (
		CLK		: in std_logic;
		WASD		: in std_logic_vector (4 downto 0);
		K1, K2	: out std_logic_vector (7 downto 0)
	);
end BattleShip;

architecture Behavioral of BattleShip is
	type StateType is ( StartA, StartB, WinA);
	signal State : StateType;
	signal clk_10ms : std_logic;
	signal temp		: std_logic_vector (7 downto 0) := "00000001";

begin

	state_name : process (State) is
	begin
		case State is
			when StartA =>
				send start a
				State <= StartB;
			when StartB =>
				State <= WinA;
		end  case;
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
			temp(3 downto 0) <= temp(2 downto 0) & temp(3);
			K1 <= temp;
			K2 <= "00000000";
		end if;
	end process send;

end Behavioral;