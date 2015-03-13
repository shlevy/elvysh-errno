elvysh-errno
============

Functions and views for safe handling of `errno`.

The `errno_v` view is used to ensure that errno is checked every time it is set.
Because `errno` is global, this means that once it is set it must be checked
before calling any function which might set errno. As such, `errno_v` is indexed
by the `errno_state` datasort, which currently may be `free` (in which case
`errno` can be set) or `set` (in which case it must be read).

`elvysh-errno` also defines `get_errno` and `set_errno` functions for
manipulating `errno` values directly, taking proper care of `errno_v`. It is
expected that `set_errno` will be infrequently used, though, as it will be more
natural to simply augment the interface to libc functions that modify `errno` to
properly handle `errno_v`.

See [elvysh-main][1] for the recommended way to obtain an initial `free`
`errno_v`.

Future work
------------

When needed, a `zeroed` state will be added to support functions like `strtol`
for which errors can only be distinguished if `errno` is set to `0` before the
function call.

A more complex model may eventually be useful, for example to support logic like
"if `errno` is `EBADF` after `read(2)`, then the file descriptor should be
considered closed".

If it ends up being useful frequently, a prfun to explicitly ignore an error may
be added as well.

[1]: https://github.com/shlevy/elvysh-main
