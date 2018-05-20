library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BattleShip is
	Port(	A, B	: in  STD_LOGIC_VECTOR (2 downto 0);
			K1, K2	: out  STD_LOGIC_VECTOR (7 downto 0)
	);
end BattleShip;

architecture Behavioral of BattleShip is
	signal temp : std_logic_vector (7 downto 0) := "00000001";
begin
	
	send : process is
	begin
		temp <= temp(6 downto 0) & temp(7);
		K1 <= temp;
		wait for 10 ms;
	end process send;

end Behavioral;