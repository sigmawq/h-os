GCC_CROSS_COMPILER_PATH="/home/swql/opt/cross/bin/"
TARGET_DIR="../target"
echo Using cross compiler path $GCC_CROSS_COMPILER_PATH
echo Building boot.s...
if ! $GCC_CROSS_COMPILER_PATH/i686-elf-as boot.s -o boot.s -o boot.o; then echo "Some error"
fi

echo Building kernel.c...
if ! $GCC_CROSS_COMPILER_PATH/i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra; then echo "Some Error"
fi

echo building linker.ld...
if ! $GCC_CROSS_COMPILER_PATH/i686-elf-gcc -T linker.ld -o hos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc; then echo "Some Error"
fi
	
echo Building  hos.bin...
if grub-file --is-x86-multiboot hos.bin; then
  echo multiboot confirmed  
else
  echo the file is not multiboot
  exit
fi

echo building image...
cp hos.bin $TARGET_DIR/isodir/boot/hos.bin
cp grub.cfg $TARGET_DIR/isodir/boot/grub/grub.cfg
exec grub-mkrescue -o $TARGET_DIR/hos.iso $TARGET_DIR/isodir &
wait $!

echo Done!
