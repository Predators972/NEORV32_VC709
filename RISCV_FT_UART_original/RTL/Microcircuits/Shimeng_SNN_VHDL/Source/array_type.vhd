library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.fixed_pkg.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package array_type is
    
    type array_2d_SFIXED is array (NATURAL range<>) of SFIXED;
    type array_2d_STD is array (NATURAL range<>) of STD_LOGIC_VECTOR;
    type array_2d_UNSIGNED is array (NATURAL range<>) of UNSIGNED;
    type array_3d_UNSIGNED is array (NATURAL range<>) of array_2d_UNSIGNED;
    type array_3d_SFIXED is array (NATURAL range<>) of array_2d_SFIXED;
    
end array_type;

