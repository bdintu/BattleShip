library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BattleShip is
	Port(	A, B	: in  STD_LOGIC_VECTOR (2 downto 0);
			K1, K2	: out  STD_LOGIC_VECTOR (7 downto 0)
	);
end BattleShip;

architecture Behavioral of BattleShip is
begin

	K1 <= "1111111";
	K2 <= "1111111";

end Behavioral;