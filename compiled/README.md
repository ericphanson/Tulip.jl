# Instructions to generate a command-line executable for Tulip

1. Install Julia (version 1.3 preferred) on your machine. Binaries can be downloaded [here](https://julialang.org/downloads/).

2. Download `tulip_cl.jl` and `snoop.jl` from [here](https://github.com/ds4dm/Tulip.jl/tree/PkgCompiler/compiled).

2. Start Julia and install the following packages
```julia
julia> ]
pkg> add ArgParse PackageCompiler Tulip
```

4. Run the following commands:
```julia
julia> using PackageCompiler
julia> build_executable("tulip_cl.jl", snoopfile="snoop.jl", "tulip_cl")
```

If everything goes well, you should see a `builddir` directory appear.
Once the compilation is done, the executable can be found at `builddir/tulip_cl`.

5. To run the executable from the command line:
```bash
tulip_cl --Threads 1 --TimeLimit 1.0 afiro.mps
```
  * The maximum number of threads is specified by the `--Threads` argument. By default, all threads are used.
  * A time limit (in seconds) is specified by the `--TimeLimit` argument. Floating-point values are expected.

## Notes

* At this stage, Tulip only reads `.mps` files in free MPS format. These cases (encountered in 4 instances of the netlib library) typically lead to reading errors:
  * Space in variables/constraints names
  * Empty name in the RHS section.
* The `tulip_cl.so` library must be in the same folder as the executable.
* When running `tulip_cl`, only the solver's output is printed.
In particular, no solution is written (if/when a solution is found).
* Time spent reading the instance file is not counted in total runtime.