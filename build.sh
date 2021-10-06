GCC_CROSS_COMPILER_PATH="/home/swql/opt/cross/bin/"
SRC_PATH="src"
TARGET_DIR="target"
echo Using cross compiler path $GCC_CROSS_COMPILER_PATH
echo Building boot.s...
if ! $GCC_CROSS_COMPILER_PATH/i686-elf-as $SRC_PATH/boot.s -o $SRC_PATH/boot.s -o $SRC_PATH/boot.o; then echo "Some error"
fi

echo Building kernel.c...
if ! $GCC_CROSS_COMPILER_PATH/i686-elf-gcc -c $SRC_PATH/kernel.c -o $SRC_PATH/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra; then echo "Some Error"
fi

echo building linker.ld...
if ! $GCC_CROSS_COMPILER_PATH/i686-elf-gcc -T $SRC_PATH/linker.ld -o $SRC_PATH/hos.bin -ffreestanding -O2 -nostdlib $SRC_PATH/boot.o $SRC_PATH/kernel.o -lgcc; then echo "Some Error"
fi
	
echo Building  hos.bin...
if grub-file --is-x86-multiboot $SRC_PATH/hos.bin; then
  echo multiboot confirmed  
else
  echo the file is not multiboot
  exit
fi

echo building image...
cp $SRC_PATH/hos.bin $TARGET_DIR/isodir/boot/hos.bin
cp $SRC_PATH/grub.cfg $TARGET_DIR/isodir/boot/grub/grub.cfg
exec grub-mkrescue -o $TARGET_DIR/hos.iso $TARGET_DIR/isodir &
wait $! 

echo Done!
