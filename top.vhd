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
	port(
		gls_clk : in  std_logic;
		--SPI interface
		spi_clk : in  std_logic;        --gpio0
		spi_din : in  std_logic;        --gpio1
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
		--		gpio0    : out  std_logic;       
		--		gpio1    : out std_logic;
		gpio2   : out std_logic;
		gpio3   : out std_logic         --trigger
	);
end top;

architecture Behavioral of top is
	-------------------------
	-- declare components  --
	-------------------------
	-------------------------
	-- Signals declaration --
	-------------------------

	--signal enable	: std_logic			:= '0';
	signal good          : std_logic                     := '0';
	signal solenoid_data : std_logic_vector(17 downto 0) := "000000000000000000";

	signal trigger_in  : std_logic                    := '0';
	signal trigger_reg : std_logic_vector(4 downto 0) := "00000";
	signal spi_clk_reg : std_logic_vector(4 downto 0) := "00000";
	signal spi_din_reg : std_logic_vector(4 downto 0) := "00000";

	--watch dog timer
	signal wd_cnt : std_logic_vector(23 downto 0) := "100110001001011010000000"; --989680
	signal wd_ctr : std_logic_vector(23 downto 0) := "000000000000000000000000";
	signal start  : std_logic                     := '0';

	--
	--	signal led0_reg     : std_logic                     := '0';
	--	signal led0_count   : std_logic_vector(23 downto 0) := "000101101110001101100000"; --0x16E360 "101101110001101100000000"; --B71B00   
	--	signal led0_counter : std_logic_vector(23 downto 0) := "000000000000000000000000";

	signal test_reg : std_logic := '0';

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
			trigger_reg <= trigger_reg(3 downto 0) & trigger_in;
			spi_clk_reg <= spi_clk_reg(3 downto 0) & spi_clk;
			spi_din_reg <= spi_din_reg(3 downto 0) & spi_din;
		end if;
	end process;

	spi_data : process(gls_clk)
	begin
		if rising_edge(gls_clk) then
			if (spi_clk_reg(4 downto 3) = "01") then --rising edge
				solenoid_data <= solenoid_data(16 downto 0) & spi_din_reg(4);
				test_reg      <= not test_reg;--'1';   --
			else
				solenoid_data <= solenoid_data;
--				test_reg      <= '0';   --
			end if;
		end if;
	end process;

	watch_dog : process(gls_clk)
	begin
		if rising_edge(gls_clk) then
			if (trigger_reg(4 downto 3) = "01") then --rising edge	
				start <= '1';
				good  <= '1';
			elsif (start = '1') then
				if (wd_ctr = wd_cnt) then
					wd_ctr <= (others => '0');
					start  <= '0';
					good   <= '0';
				else
					wd_ctr <= wd_ctr + '1';
					start  <= '1';
					good   <= '1';
				end if;
			elsif (trigger_reg(4 downto 3) = "00") then
				wd_ctr <= (others => '0');
				start  <= '0';
				good   <= '1';
			end if;
		end if;
	end process;

	intr <= (trigger_reg(4) and good);

	s0 <= solenoid_data(17);             --(trigger_reg(4) and good) and solenoid_data(0);
	s1 <= solenoid_data(16);             --(trigger_reg(4) and good) and solenoid_data(1);
	s2 <= solenoid_data(15);             --(trigger_reg(4) and good) and solenoid_data(2);
	s3 <= solenoid_data(14);             --(trigger_reg(4) and good) and solenoid_data(3);
	s4 <= solenoid_data(13);             --(trigger_reg(4) and good) and solenoid_data(4);
	s5 <= solenoid_data(12);             --(trigger_reg(4) and good) and solenoid_data(5);

	s6  <= solenoid_data(11);            --(trigger_reg(4) and good) and solenoid_data(6);
	s7  <= solenoid_data(10);            --(trigger_reg(4) and good) and solenoid_data(7);
	s8  <= solenoid_data(9);            --(trigger_reg(4) and good) and solenoid_data(8);
	s9  <= solenoid_data(8);            --(trigger_reg(4) and good) and solenoid_data(9);
	s10 <= solenoid_data(7);           --(trigger_reg(4) and good) and solenoid_data(10);
	s11 <= solenoid_data(6);           --(trigger_reg(4) and good) and solenoid_data(11);

	s12 <= solenoid_data(5);           --(trigger_reg(4) and good) and solenoid_data(12);
	s13 <= solenoid_data(4);           --(trigger_reg(4) and good) and solenoid_data(13);
	s14 <= solenoid_data(3);           --(trigger_reg(4) and good) and solenoid_data(14);
	s15 <= solenoid_data(2);           --(trigger_reg(4) and good) and solenoid_data(15);
	s16 <= solenoid_data(1);           --(trigger_reg(4) and good) and solenoid_data(16);
	s17 <= solenoid_data(0);           --(trigger_reg(4) and good) and solenoid_data(17);

	--	trigger_in <= gpio3;
	--	gpio0      <= '1';
	--	gpio1      <= '1';
	gpio2 <= test_reg;
	gpio3 <= spi_din_reg(4);
end Behavioral;

