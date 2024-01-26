gcc -o parser src/*.c -I./src \
	-I/nix/store/156k0z5829d4hfikdaycvdxw5h3qw81l-tree-sitter-0.20.8/include \
	/nix/store/156k0z5829d4hfikdaycvdxw5h3qw81l-tree-sitter-0.20.8/lib/libtree-sitter.0.0.dylib
