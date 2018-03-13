CC	=gcc
CXX	=g++
LINKER	=g++
LFLAGS	= -lm -static

object	= rect_ex.o main.o

all: ${object}
	${LINKER} ${LFLAGS} ${object} -o exe

rect_ex.o:rect_ex.cpp
	${CXX} -c -o $@ $^

main.o:main.cpp
	${CXX} -c -o $@ $^

clean:
	rm -f ${object} exe
	
