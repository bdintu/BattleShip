library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity BattleShip is
	generic (
		pattern_cycle	: integer := 2;
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
	type StateType is ( StartA, StartB, waitStartGame, randomA, randomB, bombA, bombB, WinA);
	signal State : StateType;

	type Ram3DType is array(0 to 5, 0 to 5) of integer range 0 to 3;
	signal table : Ram3DType := (
		(0,0,0,0,0,0),
		(0,0,0,0,0,0),
		(0,0,0,0,0,0),
		(0,0,0,0,0,0),
		(0,0,0,0,0,0),
		(0,0,0,0,0,0)
	);
	
	type PatternRecord is record
		x 		: integer range 0 to 5;
		y		: integer range 0 to 5;
		axis	: integer range 0 to 1;
	end record PatternRecord;
  
  	type PatternType is array (0 to pattern_cycle, 0 to 5) of PatternRecord;
	signal pattern : PatternType := (
		( (1,1,1), (2,5,1), (3,1,1), (1,1,1), (2,5,1), (3,1,1) ),
		( (1,1,1), (2,5,1), (3,1,1), (1,1,1), (2,5,1), (3,1,1) ),
		( (1,1,1), (2,5,1), (3,1,1), (1,1,1), (2,5,1), (3,1,1) )
	);

	subtype countpattern_type is integer range 0 to pattern_cycle;
	signal seed_a, seed_b : countpattern_type := 0;

	signal clk_clk	: std_logic;
	signal clk_10ms : std_logic;
	signal temp		: std_logic_vector (7 downto 0) := "00000001";

begin

	L <= "11111111";
	MN <= "11111111";

	STATUS_A <= "1111";
	POSX_A <= "111";
	POSY_A <= "111";

	STATUS_B <= "1111";
	POSX_B <= "111";
	POSY_B <= "111";

	state_name : process (State) is
		variable press_a, press_b : std_logic := '0';
	begin
		case State is
			when StartA =>
				if (clk_10ms'event and clk_10ms='1') then
					STATE_A <= "00";	-- send Start
				end if;

				State <= StartB;
			when StartB =>

				if (clk_10ms'event and clk_10ms='1') then
					STATE_B <= "00";	-- send Start
				end if;

				State <= waitStartGame;
			when waitStartGame =>

				if JOY_A(4) = '1' then
					press_a := '1';
				end if;
				if JOY_B(4) = '1' then
					press_b := '1';
				end if;

				if press_a = '1' and press_b = '1' then
					State <= randomA;
				end if;

			when randomA =>
			
				if (JOY_A(1) = '0') then
					for i in 0 to pattern_cycle loop
						for j in 0 to 5 loop
							table (pattern(i, j).x, pattern(i, j).y) <=  1;
							
							if (j=0) then
							
								if (pattern(i, j).axis = 0) then 
									for a in 1 to 2 loop
										table (pattern(i, j).x+a, pattern(i, j).y) <=  1;
									end loop;
								else
									for a in 1 to 2 loop
										table (pattern(i, j).x, pattern(i, j).y+a) <=  1;
									end loop;
								end if;

							elsif (j=1 or j=2) then

								if (pattern(i, j).axis = 0) then 
									table (pattern(i, j).x+1, pattern(i, j).y) <=  1;
								else
									for a in 0 to 1 loop
										table (pattern(i, j).x, pattern(i, j).y+a) <=  1;
									end loop;
								end if;							
								
							end if;

						end loop;
					end loop;
				end if;
				

					
				STATE_B <= "01";	-- send press key krang for seed

				
				
				State <= randomB;
			when randomB =>

				State <= bombA;
		
			when others =>
				State <= StartA;
		end case;
	end process state_name;

	clkdiv_clk : process (CLK) is
		variable count : integer range 0 to clk_cycle := 0;
	begin 
		if (CLK'event and CLK='1') then
			count := count + 1;
			if (count = clk_cycle_10ms) then
				clk_clk <= '1';
			else
				clk_clk <= '0';
			end if;
		end if;
	end process clkdiv_clk;

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
	
	joyseed_a : process (CLK) is
		variable count : countpattern_type := 0;
	begin
		if (JOY_A(1) = '1') then
			if (clk_clk'event and clk_clk='1') then
				count := count + 1;
			end if;
		end if;
		seed_a <= count;
	end process joyseed_a;
	
	joyseed_b : process (CLK) is
		variable count : countpattern_type := 0;
	begin
		if (JOY_B(1) = '1') then
			if (clk_clk'event and clk_clk='1') then
				count := count + 1;
			end if;
		end if;
		seed_b <= count;
	end process joyseed_b;

end Behavioral;