library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use WORK.TETRIS_PACKAGE.ALL;
use WORK.IMAGE_PACKAGE.ALL;
entity IMAGE_SOURCE is
 port(
 board : in BOARD_TYPE;
 next_tetrimino : in TETRIMINO_TYPE;
 next_null : in STD_LOGIC;
 hold_tetrimino : in TETRIMINO_TYPE;
 hold_null : in STD_LOGIC;
 --
 score : in INTEGER range 0 to 999999 ;
 remaining : in INTEGER range 0 to 19;
 stage : in INTEGER range 0 to 8;
 --
 x_coor : in STD_LOGIC_VECTOR (9 downto 0);
 y_coor : in STD_LOGIC_VECTOR (9 downto 0);
 vidon : in STD_LOGIC;
 --
 red : out STD_LOGIC_VECTOR (3 downto 0);
 green : out STD_LOGIC_VECTOR (3 downto 0);
 blue : out STD_LOGIC_VECTOR (3 downto 0);
 sw : in STD_LOGIC_VECTOR (2 downto 0);
 tetris : in STD_LOGIC
 );
end entity;
architecture BEHV of IMAGE_SOURCE is
 constant BOARD_POS_X : INTEGER := 240;
 constant BOARD_POS_Y : INTEGER := 80;

 constant SCORE_POS_X : INTEGER := 416;
 constant SCORE_POS_Y : INTEGER := 160;
 
constant tetris1 : std_logic_vector(2 downto 0) := "000";
constant bw : std_logic_vector(2 downto 0) := "001";
constant xmas : std_logic_vector(2 downto 0) := "010";
constant usa : std_logic_vector(2 downto 0) := "011";
constant O : std_logic_vector(2 downto 0) := "010";

begin
 process (x_coor, y_coor, vidon, board, next_tetrimino, next_null,
hold_tetrimino, hold_null, score, remaining, stage)

 variable tile_x : INTEGER := 0;
 variable tile_y : INTEGER := 0;

 variable x_coor_centered : STD_LOGIC_VECTOR (9 downto 0);
 variable y_coor_centered : STD_LOGIC_VECTOR (9 downto 0);

 variable color : BOOLEAN := FALSE;
 variable color_shape : SHAPE_TYPE := SHAPE_SQUARE;

 variable digit : INTEGER := 0;
 variable power10 : INTEGER := 0;

 variable ghost : BOOLEAN := FALSE;
 
 begin
 red <= "0000"; green <= "0000"; blue <= "0000";
 if vidon = '1' then

 

     -- BACKGROUND COLOR
     if (sw = tetris1) then
        red <= "0010"; green <= "0010"; blue <= "0010";
     elsif (sw = bw) then
        red <= "0000"; green <= "0000"; blue <= "0000";
     elsif (sw = xmas) then
        red <= "0000"; green <= "1111"; blue <= "0010";
     elsif (sw = usa) then
        red <= "0000"; green <= "0100"; blue <= "1111";
     else
        red <= "0010"; green <= "0010"; blue <= "0010";
     end if;
     
     color := FALSE;
     ghost := FALSE; --Ghost reset
     color_shape := SHAPE_SQUARE;
    
     -- PIXEL COORDINATES => TILE COORDINATES
     x_coor_centered := x_coor - BOARD_POS_X;
     y_coor_centered := y_coor - BOARD_POS_Y;
    
     tile_x := conv_integer(x_coor_centered(9 downto 4));
     tile_y := conv_integer(y_coor_centered(9 downto 4));
    
     -- BOARD
     if (0 <= tile_x) and (tile_x < BOARD_WIDTH) and
     (0 <= tile_y) and (tile_y < BOARD_HEIGHT) then
    
         if (sw = tetris1) then
            red <= "0000"; green <= "0000"; blue <= "0000";
         elsif (sw = bw) then
            red <= "1111"; green <= "1111"; blue <= "1111";
         elsif (sw = xmas) then
            red <= "0000"; green <= "0000"; blue <= "0000";
         elsif (sw = usa) then
            red <= "0000"; green <= "0000"; blue <= "0000";
         else
            red <= "0000"; green <= "0000"; blue <= "0000";
         end if;
    
         if board(tile_x, tile_y).state = "01" then
         color := TRUE;
         color_shape := board(tile_x, tile_y).shape;
         end if;
         if board(tile_x, tile_y).state = "10" then
         ghost := TRUE;
         end if;
         
     -- NEXT TETRIMINO
     elsif (BOARD_WIDTH + 1 <= tile_x) and (tile_x < BOARD_WIDTH +
    7) and
     (0 <= tile_y) and (tile_y < 4) then
    
         if (sw = tetris1) then
            red <= "0000"; green <= "0000"; blue <= "0000";
         elsif (sw = bw) then
            red <= "1111"; green <= "1111"; blue <= "1111";
         elsif (sw = xmas) then
            red <= "0010"; green <= "0000"; blue <= "0000";
         elsif (sw = usa) then
            red <= "0000"; green <= "0000"; blue <= "0000";
         else
            red <= "0010"; green <= "0010"; blue <= "0010";
         end if;
    
    if next_null = '0' then
     for i in 0 to 3 loop
     if (next_tetrimino.tiles(i).x + BOARD_WIDTH + 2 =
    tile_x) and
     (next_tetrimino.tiles(i).y + 1 = tile_y) then
    
    color := TRUE;
     color_shape := next_tetrimino.shape;
    
     end if;
     end loop;
     end if;
    
     -- HOLD TETRIMINO
     elsif (-7 <= tile_x) and (tile_x < -1) and
     (0 <= tile_y) and (tile_y < 4) then
    
         if (sw = tetris1) then
            red <= "0000"; green <= "0000"; blue <= "0000";
         elsif (sw = bw) then
            red <= "1111"; green <= "1111"; blue <= "1111";
         elsif (sw = xmas) then
            red <= "0010"; green <= "0000"; blue <= "0000";
         elsif (sw = usa) then
            red <= "0000"; green <= "0000"; blue <= "0000";
         else
            red <= "0010"; green <= "0010"; blue <= "0010";
         end if;
    
    if hold_null = '0' then
     for i in 0 to 3 loop
     if (hold_tetrimino.tiles(i).x - 6 = tile_x) and
     (hold_tetrimino.tiles(i).y + 1 = tile_y) then
     
     color := TRUE;
     color_shape := hold_tetrimino.shape;
    
     end if;
     end loop;
     end if;
    
     end if;
    
     -- SHAPE => COLOR
     if color then
         if (sw = tetris1) then           
             if color_shape = SHAPE_T then
             red <= "1100"; green <= "0000"; blue <= "1100";
             elsif color_shape = SHAPE_SQUARE then
             red <= "1111"; green <= "1111"; blue <= "0000";
             elsif color_shape = SHAPE_LINE then
             red <= "0000"; green <= "1111"; blue <= "1111";
             elsif color_shape = SHAPE_L_LEFT then
             red <= "0000"; green <= "0000"; blue <= "1111";
             elsif color_shape = SHAPE_L_RIGHT then
             red <= "1111"; green <= "1010"; blue <= "0000";
             elsif color_shape = SHAPE_Z_LEFT then
             red <= "1111"; green <= "0000"; blue <= "0000";
             else --SHAPE_Z_RIGHT
             red <= "0000"; green <= "1111"; blue <= "0000";
             end if;
         elsif (sw = bw) then
            red <= "0010"; green <= "0010"; blue <= "0010";
         elsif (sw = xmas) then
             if color_shape = SHAPE_T then
             red <= "1111"; green <= "1111"; blue <= "1111";
             elsif color_shape = SHAPE_SQUARE then
             red <= "1111"; green <= "1111"; blue <= "0000";
             elsif color_shape = SHAPE_LINE then
             red <= "0000"; green <= "1111"; blue <= "1111";
             elsif color_shape = SHAPE_L_LEFT then
             red <= "1111"; green <= "0000"; blue <= "0000";
             elsif color_shape = SHAPE_L_RIGHT then
             red <= "0000"; green <= "0000"; blue <= "1111";
             elsif color_shape = SHAPE_Z_LEFT then
             red <= "1111"; green <= "1111"; blue <= "0000";
             else --SHAPE_Z_RIGHT
             red <= "0010"; green <= "0010"; blue <= "0010";
             end if;
         elsif (sw = usa) then
             if color_shape = SHAPE_T then
             red <= "0000"; green <= "1111"; blue <= "1111";
             elsif color_shape = SHAPE_SQUARE then
             red <= "1111"; green <= "0000"; blue <= "1111";
             elsif color_shape = SHAPE_LINE then
             red <= "0000"; green <= "0000"; blue <= "1111";
             elsif color_shape = SHAPE_L_LEFT then
             red <= "1111"; green <= "0000"; blue <= "0000";
             elsif color_shape = SHAPE_L_RIGHT then
             red <= "1111"; green <= "1111"; blue <= "1111";
             elsif color_shape = SHAPE_Z_LEFT then
             red <= "0000"; green <= "1111"; blue <= "0000";
             else --SHAPE_Z_RIGHT
             red <= "1000"; green <= "1000"; blue <= "1000";
             end if;
         else
             red <= "1111"; green <= "1111"; blue <= "1111";
         end if;
     end if;
     if ghost then
        red <= "0010"; green <= "0010"; blue <= "0010";
        end if;
     
     -- Recenter the origin to the left side of the play area
     tile_x := conv_integer(x_coor_centered(9 downto 1));
     tile_y := conv_integer(y_coor_centered(9 downto 1));
    
     -- TITLE
     for i in 0 to 10 loop
         if (5 * i + 12 <= tile_x) and (tile_x < 5 * i + 4 + 12) and
         (-8 <= tile_y) and (tile_y < -1) then
        
             if CHAR_ARRAY(i)(tile_y + 8, tile_x - 5 * i - 12) then
             red <= "1111"; green <= "1111"; blue <= "1111";
             end if;
         end if;
     end loop;
    
     -- HOLD
     for i in 0 to 3 loop
         if (5 * i - 28 <= tile_x) and (tile_x < 5 * i + 4 -28) and
         (-8 <= tile_y) and (tile_y < -1) then
        
             if HOLD_ARRAY(i)(tile_y + 8, tile_x - 5 * i + 28) then
             red <= "1111"; green <= "1111"; blue <= "1111";
             end if;
         end if;
     end loop;
    
     
     -- PIXEL_COORDINATES => NUMBER_COORDINATES
     x_coor_centered := x_coor - SCORE_POS_X;
     y_coor_centered := y_coor - SCORE_POS_Y;
    
    -- Recenter the origin to the right of the play area
     tile_x := conv_integer(x_coor_centered(9 downto 1));
     tile_y := conv_integer(y_coor_centered(9 downto 1));
    
     -- NEXT sign
     for i in 0 to 3 loop
         if (5 * i <= tile_x) and (tile_x < 5 * i + 4) and
         (-47 <= tile_y) and (tile_y < -40) then
        
             if NEXT_ARRAY(i)(tile_y + 47, tile_x - 5 * i) then
             red <= "1111"; green <= "1111"; blue <= "1111";
             end if;
         end if;
     end loop;
    
     -- SCORE
     for i in 0 to 4 loop
         if (5 * i <= tile_x) and (tile_x < 5 * i + 4) and
         (0 <= tile_y) and (tile_y < 7) then
        
             if SCORE_ARRAY(i)(tile_y, tile_x - 5 * i) then
             red <= "1111"; green <= "1111"; blue <= "1111";
             end if;
         end if;
     end loop;
     power10 := 100000;
     for i in 0 to 5 loop
     if (5 * i + 30 <= tile_x) and (tile_x < 5 * i + 34) and
     (0 <= tile_y) and (tile_y < 7) then
    
    if DIGIT_ARRAY(digit_of_integer(score, 6 - i))(tile_y,
    tile_x - 5 * i - 30) then
     red <= "1111"; green <= "1111"; blue <= "1111";
     end if;
    
     end if;
     end loop;
    
     -- REMAINING
     for i in 0 to 4 loop
         if (5 * i <= tile_x) and (tile_x < 5 * i + 4) and
         (10 <= tile_y) and (tile_y < 17) then
        
             if LINES_ARRAY(i)(tile_y - 10, tile_x - 5 * i) then
             red <= "1111"; green <= "1111"; blue <= "1111";
             end if;
         end if;
     end loop;
     power10 := 10;
     for i in 0 to 1 loop
         if (5 * i + 30 <= tile_x) and (tile_x < 5 * i + 4+ 30) and
         (10 <= tile_y) and (tile_y < 17) then
        
             if DIGIT_ARRAY(digit_of_integer(remaining + 1, 2 -
            i))(tile_y - 10, tile_x - 5 * i - 30) then
             red <= "1111"; green <= "1111"; blue <= "1111";
             end if;
        
        
         end if;
     end loop;
    
    
     -- STAGE
     for i in 0 to 4 loop
         if (5 * i <= tile_x) and (tile_x < 5 * i + 4) and
         (20 <= tile_y) and (tile_y < 27) then
        
             if STAGE_ARRAY(i)(tile_y - 20, tile_x - 5 * i) then
                 red <= "1111"; green <= "1111"; blue <= "1111";
             end if;
         end if;
     end loop;
     
     if (30 <= tile_x) and (tile_x < 34) and
     (20 <= tile_y) and (tile_y < 27) then
    
         if DIGIT_ARRAY(stage + 1)(tile_y - 20, tile_x - 30) then
         red <= "1111"; green <= "1111"; blue <= "1111";
         end if;
    
     end if;
    
     
    -- TETRIS
    if (tetris = '1') then
     for i in 0 to 5 loop
         if (5 * i <= tile_x) and (tile_x < 5 * i + 4) and
         (30 <= tile_y) and (tile_y < 37) then
        
             if CHAR_ARRAY(i)(tile_y - 30, tile_x - 5 * i) then
             red <= "1111"; green <= "1111"; blue <= "1111";
             end if;
        
         end if;
     end loop;
    end if;

     
 end if;
 end process;
end architecture;
