LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Project IS
    PORT (
        start, clock, sensor : IN STD_LOGIC;
        alarm : BUFFER STD_LOGIC;
        pwm , ledA , ledP : OUT STD_LOGIC
    );
END Project;

ARCHITECTURE take OF Project IS
SIGNAL timer : INTEGER RANGE 0 TO 10;
    SIGNAL numticks : INTEGER RANGE 0 TO 50000000;
    SIGNAL secondPassed : STD_LOGIC;
    SIGNAL waitingForHim : STD_LOGIC;
	 SIGNAL khado : STD_LOGIC;

BEGIN

    -- Counts to 50MHz and when it finishes signals that a second has Passed
    PROCESS (clock)
    BEGIN

        IF (clock'EVENT AND clock = '1') THEN
            secondPassed <= '0';

            IF (numticks < 50000000) THEN
                numticks <= numticks + 1;
            ELSE
                numticks <= 0;
                secondPassed <= '1';
            END IF;
        END IF;
    END PROCESS;
	
    PROCESS (secondPassed )
    BEGIN
        IF (clock'EVENT AND clock = '1') THEN
            IF (secondPassed = '1' AND timer < 10 AND waitingForHim = '0' ) THEN
                timer <= timer + 1;
            ELSIF (timer = 9) THEN
                waitingForHim <= '1';
            END IF;
            IF (start = '0' OR khado = '1') THEN
                waitingForHim <= '0';
                timer <= 0;
            END IF;

        END IF;
    END PROCESS;
	PROCESS (start, waitingForHim ,sensor)
    BEGIN
        IF (clock'EVENT AND clock = '1') THEN
            IF (start = '1') THEN
                IF (waitingForHim = '1' AND sensor = '0') THEN
                    alarm <= '1';
                    ledA <= '1';
                    pwm <= '0';
                    ledP <= '0';
                ELSIF ((waitingForHim = '1' OR khado = '0') AND sensor = '1' ) THEN
                    alarm <= '0';
                    ledA <= '0';
                    pwm <= '1';
                    ledP <= '1';
						  khado <= '1';
                ELSIF (waitingForHim = '0') THEN
                    alarm <= '0';
                    ledA <= '0';
                    pwm <= '0';
                    ledP <= '0';
						  khado <= '0';
                END IF;
            ELSE
                alarm <= '0';
                ledA <= '0';
                pwm <= '0';
                ledP <= '0';
            END IF;
        END IF;
    END PROCESS;
END take;