#define ATS_EXTERN_PREFIX "elvysh_errno_"
#define ATS_PACKNAME "elvysh_errno_"

(* States errno can be in.
 *
 * ctors:
 * free: errno hasn't been set since last checked/handled, can call functions
 *       which may set errno.
 * set: errno has been set, must be handled before calling any other function
 *      which may set errno
 *
 * Will add a 'zeroed' state later for functions like strtol
 *)
datasort errno_state = free
                     | set

(* View gating access to errno. Note that the initial creation and final
 * consumption of errno_v should be handled by the set_posix_main macro
 * in elvysh-main, or something similar, and from then on should be threaded
 * through functions called from main
 *)
absview errno_v ( errno_state )

(* Get errno *)
fun get_errno ( ev: !errno_v ( set ) >> errno_v ( free ) ): int
  = "mac#%"

(* Set errno *)
fun set_errno ( ev: !errno_v ( free ) >> errno_v ( set ) | value: int ): void
  = "mac#%"

%{#
#include <errno.h>
#define elvysh_errno_get_errno() errno
#define elvysh_errno_set_errno(x) errno = (x)
%}
