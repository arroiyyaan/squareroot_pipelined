-- sqrt_a4

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.unsigned;

entity sqrt_a4 is
    generic (n : integer := 16);
    port(
      clk : in std_logic;
      reset : in std_logic;
      start : in std_logic;
      input : in unsigned(2*n-1 downto 0);
      done_flag : out std_logic;
      result : out unsigned(n-1 downto 0)
    );
end sqrt_a4;


architecture a4 of sqrt_a4 is

  type var_array is array (n downto 0) of unsigned(2*n-1 downto 0);
  signal num_in : var_array;
  signal V : var_array;
  signal Z_intm : var_array;

  -- signal Z0 : var_array;
  -- signal Z1 : var_array;
  -- signal Z2 : var_array;

  signal temp_result : unsigned(n-1 downto 0);

begin

  p_sqrt : process(reset, clk)
  variable Z : var_array;
  --variable Z : unsigned(2*n-1 downto 0) := (others => '0');
  begin
    if (reset = '1') then
      done_flag <= '0';
      result <= (others => '0');
      num_in(0) <= (others => '0');
      V(0) <= (others => '0');
      Z_intm(0) <= (others => '0');
      Z(0) := (others => '0');

      temp_result <= (others => '0');

    elsif (rising_edge(clk)) then
      if (start = '1') then
        -- reg(0) <= '1';

        num_in(0) <= input;
        V(0) <= (2*n-2 => '1', others => '0');
        Z_intm(0) <= (others => '0');
        Z(0) := (others => '0');

      -- else
        -- reg(0) <= '0';
      end if;

      for i in 0 to n-1 loop

        Z(i) := Z_intm(i) + V(i);
        -- runreg(i+1) <= reg(i);
        if (signed(num_in(i)-Z(i)) >= 0) then
            num_in(i+1) <= num_in(i) - Z(i);
            Z(i) := Z(i) + V(i);
            --num_in(i+1) <= num_in(i);
        else
            Z(i) := Z(i) - V(i);
            num_in(i+1) <= num_in(i);
        end if;
        Z_intm(i+1) <= Z(i)/2;
        V(i+1) <= V(i)/4;

        if (i = 0) then
          -- done_flag <= '1';
          temp_result <= resize(Z(n-1)/2, temp_result'length);
          -- result <= temp_result;
          -- num_in(0) <= input;
          -- V(0) <= (2*n-2 => '1', others => '0');
          -- Z(0) := (others => '0');
        end if;
      end loop;
    end if;
    result <= temp_result;
    -- temp_result <= resize(Z(n-1), result'length);
  end process;
  -- result <= temp_result; -- result is not yet readeable to the processor

end architecture;
