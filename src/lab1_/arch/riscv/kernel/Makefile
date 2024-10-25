ASM_SRC		= $(sort $(wildcard *.S))
C_SRC       = $(sort $(wildcard *.c))
OBJ		    = $(patsubst %.S,%.o,$(ASM_SRC)) $(patsubst %.c,%.o,$(C_SRC))

all:$(OBJ)

%.o:%.S
	${GCC}  ${CFLAG} -c -g $<

%.o:%.c
	${GCC}  ${CFLAG} -c -g $<

clean:
	$(shell rm *.o 2>/dev/null)
