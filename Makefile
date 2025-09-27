all: bin
	sh build/build.sh
bin:
	cc -static -o rurima src/rurima-wrapper.c
	cc -static -o curl src/curl-wrapper.c
	cc -static -o file src/file-wrapper.c
	strip rurima curl file
format:
	clang-format -i src/*.c