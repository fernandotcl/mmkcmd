## Introduction

mmkcmd is a simple utility for OS X that maps multimedia keys to commands specified on the command line. This can be particurly useful in combination with music players such as [Cmus][], but mmkcmd can also be used to simply prevent iTunes from launching when the multimedia keys are pressed.

[Cmus]:(http://cmus.sourceforge.net/)

## Usage

Here's an example of how mmkcmd can be used in conjunction with Cmus in a script:

```bash
#!/bin/bash
set -e

mmkcmd -p 'cmus-remote -u' -f 'cmus-remote -n' -r 'cmus-remote -r' &
MMKCMD_PID=$!

/usr/local/bin/cmus

kill $MMKCMD_PID
```

All possible command line switches are documented in `mmkcmd(1)`.

## Installing

The easiest way to install mmkcmd is through [Homebrew][]. There is a formula for mmkcmd in [my Homebrew tap][tap].

[homebrew]: http://mxcl.github.com/homebrew/
[tap]: https://github.com/fernandotcl/homebrew-fernandotcl

If you're compiling from source, you will only need the developer tools and [CMake][].

[cmake]: http://www.cmake.org/

To compile and install:

```sh
cd /path/to/source
cmake .
make install
```

## Credits

mmkcmd was created by [Fernando Tarlá Cardoso Lemos](mailto:fernandotcl@gmail.com).

## License

mmkcmd is available under the BSD 2-clause license. See the LICENSE file for more information.