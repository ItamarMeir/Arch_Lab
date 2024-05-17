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

    FUNCTION select_output(ALUFN: std_logic_vector) RETURN std_logic_vector IS
    BEGIN
        CASE ALUFN IS
            WHEN "000" => RETURN out_mat(0);
            WHEN "001" => RETURN out_mat(1);
            WHEN "010" => RETURN out_mat(2);
            WHEN "011" => RETURN out_mat(3);
            WHEN "100" => RETURN out_mat(4);
            WHEN "101" => RETURN out_mat(5);
            WHEN "110" => RETURN out_mat(6);
            WHEN OTHERS => RETURN out_mat(7);
        END CASE;
    END FUNCTION select_output;
BEGIN
    out_mat(0) <= not Y_Logic_i;            --for ALUFN = "000"
    out_mat(1) <= Y_Logic_i or X_Logic_i;   --for ALUFN = "001"
    out_mat(2) <= Y_Logic_i and X_Logic_i;  --for ALUFN = "010"
    out_mat(3) <= Y_Logic_i xor X_Logic_i;  --for ALUFN = "011"
    out_mat(4) <= Y_Logic_i nor X_Logic_i;  --for ALUFN = "100"
    out_mat(5) <= Y_Logic_i nand X_Logic_i; --for ALUFN = "101"
    out_mat(6) <= (others => '0');          --for ALUFN = "110"
    out_mat(7) <= Y_Logic_i xnor X_Logic_i; --for ALUFN = "111"

    Logic_o <= select_output(ALUFN);
END ARCHITECTURE Log_Arch;