library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity music is
 port(
     clock_m : in STD_LOGIC;
     reset : in STD_LOGIC;
     state : in STD_LOGIC_VECTOR(2 downto 0);
     --
     audio_out : out STD_LOGIC
 );
end music;

architecture Behavioral of music is
	constant rest: std_logic_vector(7 downto 0) := x"00";
	constant C4  : std_logic_vector(7 downto 0) := x"01";
	constant C4S : std_logic_vector(7 downto 0) := x"02";
	constant D4  : std_logic_vector(7 downto 0) := x"03";
	constant D4S : std_logic_vector(7 downto 0) := x"04";
	constant E4  : std_logic_vector(7 downto 0) := x"05";
	constant F4  : std_logic_vector(7 downto 0) := x"06";
	constant F4S : std_logic_vector(7 downto 0) := x"07";
	constant G4  : std_logic_vector(7 downto 0) := x"08";
	constant G4S : std_logic_vector(7 downto 0) := x"09";
	constant A4  : std_logic_vector(7 downto 0) := x"0a";
	constant A4S : std_logic_vector(7 downto 0) := x"0b";
	constant B4  : std_logic_vector(7 downto 0) := x"0c";
	constant C5  : std_logic_vector(7 downto 0) := x"0d";
	constant C5S : std_logic_vector(7 downto 0) := x"0e";
	constant D5  : std_logic_vector(7 downto 0) := x"0f";
	constant D5S : std_logic_vector(7 downto 0) := x"10";
	constant E5  : std_logic_vector(7 downto 0) := x"11";
	constant F5  : std_logic_vector(7 downto 0) := x"12";
	constant F5S : std_logic_vector(7 downto 0) := x"13";
	constant G5  : std_logic_vector(7 downto 0) := x"14";
	constant G5S : std_logic_vector(7 downto 0) := x"15";
	constant A5  : std_logic_vector(7 downto 0) := x"16";
	constant A5S : std_logic_vector(7 downto 0) := x"17";
	constant B5  : std_logic_vector(7 downto 0) := x"18";
	constant MAX : natural := 12_499_999;
	constant tetris : std_logic_vector(2 downto 0) := "000";
	constant bw : std_logic_vector(2 downto 0) := "001";
	constant xmas : std_logic_vector(2 downto 0) := "010";
	constant usa : std_logic_vector(2 downto 0) := "011";
	constant O : std_logic_vector(2 downto 0) := "010";
	-----
	signal count : natural := 0;
	signal count_next : natural;
	signal note : std_logic_vector(7 downto 0) := rest;
	signal note_next : std_logic_vector(7 downto 0);
	signal c4p,d4p,e4p,f4p,g4p,a4p,b4p,c4sp,d4sp,f4sp,g4sp,a4sp,c5p,d5p, 
	       e5p,f5p,g5p,a5p,b5p,c5sp,d5sp,f5sp,g5sp,a5sp : std_logic;	
	signal ptr_gp, ptr_t, ptr_o, ptr_s : natural := 0;	
	signal ptr_gp_nxt, ptr_t_nxt, ptr_o_nxt, ptr_s_nxt : natural;
	-----
	type gp_song is array (0 to 39) of std_logic_vector(7 downto 0);
	signal game_song : gp_song := (
											 E5, B4, C5, D5, C5, B4, A4, 
											 A4, C5, E5, D5, C5, B4, 
											 C5, D5, E5, C5, A4, A4, rest,
											 D5, F5, A5, G5, F5, E5, rest,
											 C5, E5, D5, C5, B4, 
											 B4, C5, D5, E5, C5, A4, A4, rest);		
											 	 
	type t_song is array (0 to 23) of std_logic_vector(7 downto 0);
	signal take_on_me : t_song := (
											 F5S, F5S, D5, B4, B4, E5, E5, E5, 
											 G5S, G5S, A5, B5, A5, A5, A5, E5, 
											 D5, F5S, F5S, F5S, E5, E5, F5S, E5);	
											 
    type o_song is array (0 to 60) of std_logic_vector(7 downto 0);
	signal ode_to_joy : o_song := (
											E5, E5, F5, G5, G5, F5, E5, D5, C5, C5, D5, E5 ,E5, D5, D5,
                                            E5, E5, F5, G5, G5, F5, E5, D5, C5, C5, D5, E5, D5, C5, C5,
                                            D5, E5, C5, D5, E5, F5, E5, C5, D5, E5, F5, E5, D5, C5, D5, G4,
                                            E5, E5, F5, G5, G5, F5, E5, D5, C5, C5, D5, E5, D5, C5, C5);										
		
	type s_song is array (0 to 26) of std_logic_vector(7 downto 0);
	signal sonic_song : s_song := (
											G5, E4, C4, E4, G4, C5, C5, 
											E5, D5, C5, E4, F4S, G4, rest, G4,
											E5, D5, C5, B4, B4, A4, B4, C5,
											C5, G4, E4, C4);			 						
											
											 	
																		
begin


	process(clock_m)
	begin
	    if reset='1' then
	       count <= 0;
	       note <= rest;
	       ptr_gp <= 0;
	       ptr_t <= 0;
	       ptr_o <= 0;
	       ptr_s <= 0;
		elsif clock_m'event and clock_m = '1' then
            count <= count_next;
            note <= note_next;
            ptr_gp <= ptr_gp_nxt;
            ptr_t <= ptr_t_nxt;
            ptr_o <= ptr_o_nxt;
            ptr_s <= ptr_s_nxt;
		end if;
	end process;
	
	count_next <= count+1 when count < MAX else 0;
	
	ptr_gp_nxt <= ptr_gp+1 when ptr_gp < 39 and count=MAX and state=tetris else
					  0 when ptr_gp=39 and state=tetris and count=MAX else
					  ptr_gp;
					  
	ptr_t_nxt <= ptr_t+1 when ptr_t < 23 and count=MAX and state=bw else
					  0 when ptr_t=23 and state=bw and count=MAX else
					  ptr_t;
					  
	ptr_o_nxt <= ptr_o+1 when ptr_o < 60 and count=MAX and state=xmas else
					  0 when ptr_o=60 and state=xmas and count=MAX else
					  ptr_o;
					  
	ptr_s_nxt <= ptr_s+1 when ptr_s < 26 and count=MAX and state=usa else
					  0 when ptr_s=26 and state=usa and count=MAX else
					  ptr_s;			
					 
	note_gen : entity work.note_generator
		port map(
					clock_m => clock_m,
					C4	=> c4p,
					D4	=>	d4p,
					E4	=>	e4p, 
					F4	=>	f4p, 
					G4	=>	g4p, 
					A4	=>	a4p, 
					B4	=>	b4p, 			
					C4S => c4sp,
					D4S => d4sp,
					F4S => f4sp,
					G4S => g4sp,
					A4S => a4sp,	 
					C5	=>	c5p, 
					D5	=>	d5p, 
					E5	=>	e5p,
					F5	=>	f5p, 
					G5	=>	g5p, 
					A5	=>	a5p, 
					B5	=>	b5p, 
					C5S => c5sp,
					D5S => d5sp,
					F5S => f5sp,
					G5S => g5sp,
					A5S => a5sp	
			);
	
	note_next <= sonic_song(ptr_s) when state=usa 
	                               else take_on_me(ptr_t) when state=bw
	                               else ode_to_joy(ptr_o) when state=xmas
	                               else game_song(ptr_gp);
	
	audio_out <= c4p when note=C4 else
	             d4p when note=D4 else
	             e4p when note=E4 else
	             f4p when note=F4 else
	             g4p when note=G4 else
	             a4p when note=A4 else
	             b4p when note=B4 else
	             c4sp when note=C4S else
	             d4sp when note=D4S else
	             f4sp when note=F4S else
	             g4sp when note=G4S else
	             a4sp when note=A4S else
	             c5p when note=C5 else
	             d5p when note=D5 else
	             e5p when note=E5 else
	             f5p when note=F5 else
	             g5p when note=G5 else
	             a5p when note=A5 else
	             b5p when note=B5 else
	             c5sp when note=C5S else
	             d5sp when note=D5S else
	             f5sp when note=F5S else
	             g5sp when note=G5S else
	             a5sp when note=A5S else
					 '0';

end Behavioral;
