library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BattleShip is
	Port(	A, B	: in  STD_LOGIC_VECTOR (2 downto 0);
			C		: out  STD_LOGIC_VECTOR (6 downto 0)
	);
end exvf2;

architecture Behavioral of BattleShip is
begin

	C <= "1100111";

end Behavioral;