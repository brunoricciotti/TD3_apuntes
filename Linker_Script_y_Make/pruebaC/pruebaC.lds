SECTIONS
{
  .stack :
    {*(.stack)}
    
  . = 0x00010000;
  .bss :
     {*(.bss)}
		
  . = 0xFFFF0000;
  .init :  AT (0xFFFF0000)
     {*(.text*) *(.eh_frame) *(.note.gnu.property)}
 		
  . = 0xFFFFFFF0;
  .reset : AT (0xFFFFFFF0)
     {*(.reset)}
}
