\ Array memory is organized as follows
\ 
\ [cell]: number of allocated elements
\ [cell]: number of used elements
\ [cell]: first array element
\ [cell]: second array element
\ ...
\ [cell]: last array element
\
\
\ The array can double its size automatically if use! detects it needs a new element

10 constant minsize
02 constant /head

: size  ( a -- ) ;
: used  ( a -- )    cell+ ;
: elem  ( a i -- )  /head + cells + ;
: use!  ( a -- )    1 swap  used +! ;
: last  ( a -- )    dup used @ elem ;

: ?autosize  ( n -- n )
  dup 0= if drop minsize then ;

: darray
  ?autosize dup /head + cells allocate throw >r
  r@ size !
  0 r@ used !
  r> ;

: grow?  ( a -- f )  dup size @  swap used @ = ;
: dupsize  ( a -- n )  size @ 2 * ;

: ?grow  ( a -- a )
  dup grow? if
    dup dupsize dup >r /head + cells resize throw
    r> over size !
  then ;

: append  ( n a -- a )
  ?grow >r r@ last ! r@ use!  r> ;


1 [if]

( Testing )
: .hex      base @ >r hex . r> base ! ;
: time      cputime d+ d>s ;

: .address  ." address: " dup .hex ;
: .size     ." size: " dup size @ . ;
: .used     ." used: " dup used @ . ;

: .elements
  dup used @ 0= if drop drop exit then
  dup used @ 0 do
    i . space  dup i elem @ .  cr
  loop drop ;

: .darray  ( a -- )
  .address cr
  .size cr
  .used cr ;

create 'my 0 ,
: my!  'my ! ;
: my   'my @ ;
: myinit  0 darray my! ;

: mytest
  myinit 30 0 do
    i 2* my append my!
  loop
  cr my .darray
  ." elements: " cr my .elements ;

: runbench
  1000 0 do
    myinit 1000 0 do
      i my append my!
    loop
  loop ;

: bench
  time runbench time
  swap - . ." us" ;

[then]
