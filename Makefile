all:
	touch rurima-real file tar xz gzip curl sha256sum proot newuidmap newgidmap
	chmod +x rurima-real file tar xz gzip curl sha256sum proot newuidmap newgidmap
	cc -static -o rurima src/rurima-wrapper.c
format:
	clang-format -i src/*.c