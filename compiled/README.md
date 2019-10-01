# Instructions to generate a command-line executable for Tulip

1. Install Julia (version 1.0 preferred) on your machine. Binaries can be downloaded [here](https://julialang.org/downloads/).
2. Checkout Tulip for development
```julia
julia> ]
pkg> add PkgCompiler
pkg> dev Tulip
```
then `cd` to the package location (should be `~/.julia/dev/Tulip`) and checkout the `PkgCompiler` branch
```bash
cd ~/.julia/dev/Tulip
git checkout PkgCompiler
```
2. Make sure all required packages are installed (this will download and install all required packages)
```julia
julia> ]
pkg> instantiate
```

3. Start Julia from the root of the `Tulip` directory
```julia
julia> using PackageCompiler
julia> build_executable("compiled/tulip_cl.jl", snoopfile="compiled/snoop.jl", "tulip_cl")
```

If everything goes well, you should see a `builddir` directory appear: `.julia/dev/Tulip/builddir`.
Once the compilation is done, the executable can be found at `.julia/dev/Tulip/builddir/tulip_cl`.

4. To run the executable from the command line:
```bash
tulip_cl afiro.mps
```

## Notes

* At this stage, Tulip only reads `.mps` files in standard format (i.e., neither free MPS format nor LP format are supported yet).
* The `tulip_cl.so` library must be in the same folder as the executable.
* When running `tulip_cl`, only the solver's output is printed.
In particular, no solution is written (if/when a solution is found).
* Tulip has no dense column management, so expect several memory errors on large problems.
* There is currently no option to provide a time limit to the command line executable.