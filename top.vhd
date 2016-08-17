----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:56:02 07/11/2016 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity top is
	generic(
		cnt_on  : integer := 600000;    --50ms 300000;--25ms 3000000;--250ms
		cnt_off : integer := 2400000    --200ms--1200000--100ms 12000000--1sec
	);
	port(
		gls_clk : in  std_logic;
		--SPI interface
		spi_clk : in  std_logic;
		spi_din : in  std_logic;
		--logic
		intr    : out std_logic;
		--Solenoids
		s0      : out std_logic;
		s1      : out std_logic;
		s2      : out std_logic;
		s3      : out std_logic;
		s4      : out std_logic;
		s5      : out std_logic;
		s6      : out std_logic;
		s7      : out std_logic;
		s8      : out std_logic;
		s9      : out std_logic;
		s10     : out std_logic;
		s11     : out std_logic;
		s12     : out std_logic;
		s13     : out std_logic;
		s14     : out std_logic;
		s15     : out std_logic;
		s16     : out std_logic;
		s17     : out std_logic;
		gpio0   : in  std_logic;        --trigger      
		gpio1   : out std_logic;
		gpio2   : out std_logic;
		gpio3   : out std_logic
	);
end top;

architecture Behavioral of top is
	-------------------------
	-- declare components  --
	-------------------------
	-------------------------
	-- Signals declaration --
	-------------------------
	signal solenoid_data : std_logic_vector(17 downto 0) := "111101010101010101";--0x15

	signal trigger_in  : std_logic                    := '0';
	signal trigger_reg : std_logic_vector(2 downto 0) := "000";
	signal spi_clk_reg : std_logic_vector(2 downto 0) := "000";

	--watch dog timer
	signal ctr   : std_logic_vector(23 downto 0) := "000000000000000000000000";
	signal start : std_logic                     := '0';
	signal oe    : std_logic                     := '0';
--
--	signal led0_reg     : std_logic                     := '0';
--	signal led0_count   : std_logic_vector(23 downto 0) := "000101101110001101100000"; --0x16E360 "101101110001101100000000"; --B71B00   
--	signal led0_counter : std_logic_vector(23 downto 0) := "000000000000000000000000";

--signal test_reg : std_logic := '0';

begin                                   -- architecture body
	-------------------------
	-- declare instance -----
	-------------------------

	--------------------------
	-- process blocks --------
	--------------------------
	--------------------------
	-- process blocks --------
	--------------------------  
	--	clk_divider : process(gls_clk)
	--	begin
	--		if rising_edge(gls_clk) then
	--			if (led0_counter = led0_count) then
	--				led0_reg     <= not led0_reg;
	--				led0_counter <= (others => '0');
	--			else
	--				led0_reg     <= led0_reg;
	--				led0_counter <= led0_counter + '1';
	--			end if;
	--		end if;
	--	end process;

	meta : process(gls_clk)
	begin
		if rising_edge(gls_clk) then
			trigger_reg <= trigger_reg(1 downto 0) & trigger_in;
			spi_clk_reg <= spi_clk_reg(1 downto 0) & spi_clk;
		end if;
	end process;

	spi_data : process(gls_clk)
	begin
		if rising_edge(gls_clk) then
			if (spi_clk_reg(2 downto 1) = "01") then --rising edge
				solenoid_data <= solenoid_data(16 downto 0) & spi_din;
			else
				solenoid_data <= solenoid_data;
			end if;
		end if;
	end process;

	op_en : process(gls_clk)
	begin
		if rising_edge(gls_clk) then
			if (start = '1') then
				if (ctr < conv_integer(cnt_on)) then
					ctr   <= ctr + '1';
					oe    <= '1';
					start <= '1';
				elsif ((ctr >= conv_integer(cnt_on)) and (ctr < conv_integer(cnt_off))) then
					ctr   <= ctr + '1';
					oe    <= '0';
					start <= '1';
				else
					ctr   <= (others => '0');
					oe    <= '0';
					start <= '0';
				end if;
			else
				oe  <= '0';
				ctr <= (others => '0');
				if (trigger_reg(2 downto 1) = "01") then
					start <= '1';
				else
					start <= '0';
				end if;
			end if;
		end if;
	end process;

	intr       <= (oe);
	trigger_in <= gpio0;
	gpio1      <= (oe);

	s0 <= (oe) and solenoid_data(17);
	s1 <= (oe) and solenoid_data(16);
	s2 <= (oe) and solenoid_data(15);
	s3 <= (oe) and solenoid_data(14);
	s4 <= (oe) and solenoid_data(13);
	s5 <= (oe) and solenoid_data(12);

	s6  <= (oe) and solenoid_data(11);
	s7  <= (oe) and solenoid_data(10);
	s8  <= (oe) and solenoid_data(9);
	s9  <= (oe) and solenoid_data(8);
	s10 <= (oe) and solenoid_data(7);
	s11 <= (oe) and solenoid_data(6);

	s12 <= (oe) and solenoid_data(5);
	s13 <= (oe) and solenoid_data(4);
	s14 <= (oe) and solenoid_data(3);
	s15 <= (oe) and solenoid_data(2);
	s16 <= (oe) and solenoid_data(1);
	s17 <= (oe) and solenoid_data(0);

	gpio2 <= '0';
	gpio3 <= '0';

end Behavioral;

