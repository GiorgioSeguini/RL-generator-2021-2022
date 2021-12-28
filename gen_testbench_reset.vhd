-- Change paths at lines 65, 141, 144 -

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_textio.all;
use STD.textio.all;

entity project_tb is
end project_tb;

architecture projecttb of project_tb is
  constant c_CLOCK_PERIOD       : time := 100 ns;
  signal tb_done                : std_logic;
  signal mem_address            : std_logic_vector (15 downto 0) := (others => '0');
  signal tb_rst                 : std_logic                      := '0';
  signal tb_start               : std_logic                      := '0';
  signal tb_clk                 : std_logic                      := '0';
  signal mem_o_data, mem_i_data : std_logic_vector (7 downto 0);
  signal enable_wire            : std_logic;
  signal mem_we                 : std_logic;

  type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);

  signal RAM              : ram_type;
  signal s_read_done      : boolean := false;
  signal s_read           : boolean := false;
  shared variable num : integer;

  component project_reti_logiche is
    port (
      i_clk     : in std_logic;
      i_start   : in std_logic;
      i_rst     : in std_logic;
      i_data    : in std_logic_vector(7 downto 0);
      o_address : out std_logic_vector(15 downto 0);
      o_done    : out std_logic;
      o_en      : out std_logic;
      o_we      : out std_logic;
      o_data    : out std_logic_vector (7 downto 0)
    );
  end component project_reti_logiche;
begin
  UUT : project_reti_logiche
  port map(
    i_clk     => tb_clk,
    i_start   => tb_start,
    i_rst     => tb_rst,
    i_data    => mem_o_data,
    o_address => mem_address,
    o_done    => tb_done,
    o_en      => enable_wire,
    o_we      => mem_we,
    o_data    => mem_i_data
  );

  p_CLK_GEN : process is
  begin
    wait for c_CLOCK_PERIOD/2;
    tb_clk <= not tb_clk;
  end process p_CLK_GEN;

  MEM : process (tb_clk)
    file read_file     : text open read_mode is "DIRECTORY\ram_content.txt"; --<<<<<<<<<<<<<<<<--------------------------------- QUI DA CAMBIARE
    variable read_line : line;
    variable R         : ram_type;
    variable handler   : integer;

  begin
    if tb_clk'event and tb_clk = '1' then
      if s_read then
        readline(read_file, read_line);
        read(read_line, num);
        RAM(0) <= std_logic_vector(to_unsigned(num, 8));
        for i in 1 to (num) loop
          readline(read_file, read_line);
          read(read_line, handler);
          RAM(i) <= std_logic_vector(to_unsigned(handler, 8));
        end loop;
        for i in 0 to (2 * num -1) loop
          readline(read_file, read_line);
          read(read_line, handler);
          RAM(3000 + i) <= std_logic_vector(to_unsigned(handler, 8));
        end loop;
        if endfile(read_file) then
          s_read_done <= true;
        end if;
      elsif enable_wire = '1' then
        if mem_we = '1' then
          RAM(conv_integer(mem_address)) <= mem_i_data;
          mem_o_data                     <= mem_i_data after 1 ns;
        else
          mem_o_data <= RAM(conv_integer(mem_address)) after 1 ns;
        end if;
      end if;
    end if;
  end process;

  test : process is
    file write_file                     : text open write_mode is "DIRECTORY\passati.txt"; --<<<<<<<<<<<<<<<<--------------------------------- QUI DA CAMBIARE
    file err_write_file                 : text open write_mode is "DIRECTORY\non_passati.txt"; --<<<<<<<<<<<<<<<<--------------------------------- QUI DA CAMBIARE
    variable write_line, err_write_line : line;
    variable count                      : integer := 0;
    variable passed                     : boolean := true;
    variable errors                     : boolean := false;
  begin
    wait for 100 ns;
    loop

      count := count + 1;

      if (s_read_done) then
        exit;
      end if;

      s_read <= true; -- richiesta di modifica valori ram
      wait for c_CLOCK_PERIOD;
      s_read <= false;
	  wait for c_CLOCK_PERIOD;
	  tb_rst <= '1';
      wait for c_CLOCK_PERIOD;
      tb_rst <= '0';
      wait for c_CLOCK_PERIOD;
      tb_start <= '1';
      wait for c_CLOCK_PERIOD;
      wait until tb_done = '1';
      wait for c_CLOCK_PERIOD;
      tb_start <= '0';
      wait until tb_done = '0';
      wait for c_CLOCK_PERIOD;

      for i in 0 to (2 * num -1) loop
        if (RAM(1000 + i) /= RAM(3000 + i)) then
          passed := false;
          exit;
        end if;
      end loop;

      if (passed) then
        write(write_line, integer'image(count) & string'(") PASSATO")); --- passati.txt
        writeline(write_file, write_line);
      else
        write(err_write_line, integer'image(count) & string'(") NON PASSATO")); --- non_passati.txt
        writeline(err_write_file, err_write_line);
        errors := true;
      end if;

      passed := true;
      ---------- fine casi di test ---------- 
    end loop;

    if (not errors) then
      write(err_write_line, string'("Tutti i test sono stati passati"));
      writeline(err_write_file, err_write_line);
    end if;

    file_close(write_file);
    file_close(err_write_file);
    std.env.finish;

  end process test;

end projecttb;