TBLLANG:												; $123F
				.dw			TBLENG-2
				.dw			TBLGER-2
				.dw			TBLFRA-2
				.dw			TBLSPA-2

TBLLOC:
				.dw			$3ac8
				.dw			$3ac8
				.dw			$3ac9
				.dw			$3aca

#include "zapeng.asm"
#include "zapger.asm"
#include "zapfra.asm"
#include "zapspa.asm"

				.end
