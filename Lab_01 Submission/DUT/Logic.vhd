LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;


--------------------------------------------------------
ENTITY Logic IS
    GENERIC (
        CONSTANT n : INTEGER := 8;  -- Example constant, typically set to your desired value
        CONSTANT k : INTEGER := 3;  -- log2(n), here assumed to be 3
        CONSTANT m : INTEGER := 4   -- 2^(k-1), here assumed to be 4
    );
    PORT (
        Y_Logic_i: in  std_logic_vector(n-1 DOWNTO 0);
        X_Logic_i: in  std_logic_vector(n-1 DOWNTO 0);
        ALUFN: in STD_LOGIC_VECTOR (k-1 downto 0);            --- ALUFN[2:0]
        Logic_o: out std_logic_vector(n-1 DOWNTO 0)
    );
END ENTITY Logic;

--------------------------------------------------------
ARCHITECTURE Log_Arch OF Logic IS
    TYPE Logic_mat IS ARRAY (n-1 DOWNTO 0) OF std_logic_vector(n-1 DOWNTO 0);  -- Matrix of all the optional outputs of Logic (n lines of vectors in size of n)
    SIGNAL out_mat: Logic_mat; -- Defining signal: matrix of all the optional outputs of Logic
BEGIN
    out_mat(0) <= not Y_Logic_i;            --for ALUFN = "000"
    out_mat(1) <= Y_Logic_i or X_Logic_i;   --for ALUFN = "001"
    out_mat(2) <= Y_Logic_i and X_Logic_i;  --for ALUFN = "010"
    out_mat(3) <= Y_Logic_i xor X_Logic_i;  --for ALUFN = "011"
    out_mat(4) <= Y_Logic_i nor X_Logic_i;  --for ALUFN = "100"
    out_mat(5) <= Y_Logic_i nand X_Logic_i; --for ALUFN = "101"
    out_mat(6) <= (others => '0');          --for ALUFN = "110"
    out_mat(7) <= Y_Logic_i xnor X_Logic_i; --for ALUFN = "111"

    with ALUFN select
    Logic_o <= out_mat(0) when "000",
                out_mat(1) when "001",
                out_mat(2) when "010",
                out_mat(3) when "011",
                out_mat(4) when "100",
                out_mat(5) when "101",
                out_mat(6) when "110",
                out_mat(7) when others;



END ARCHITECTURE Log_Arch;
