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

3. Make sure all required packages are installed (this will download and install all required packages)
```julia
julia> ]
pkg> instantiate
```

4. Start Julia from the root of the `Tulip` directory
```julia
julia> using PackageCompiler
julia> build_executable("compiled/tulip_cl.jl", snoopfile="compiled/snoop.jl", "tulip_cl")
```

If everything goes well, you should see a `builddir` directory appear: `.julia/dev/Tulip/builddir`.
Once the compilation is done, the executable can be found at `.julia/dev/Tulip/builddir/tulip_cl`.

The output on my machine looks like:
```julia
julia> using PackageCompiler

julia> build_executable("compiled/tulip_cl.jl", snoopfile="compiled/snoop.jl", "tulip_cl")
Julia program file:
  "/home/mathieu/.julia/dev/Tulip/compiled/tulip_cl.jl"
C program file:
  "/home/mathieu/.julia/packages/PackageCompiler/CJQcs/examples/program.c"
Build directory:
  "/home/mathieu/.julia/dev/Tulip/builddir"
 Itn              PObj            DObj     PFeas    DFeas    GFeas       Mu  Time
   0    +2.0000000e+00  +0.0000000e+00  1.00e+00 0.00e+00 3.00e+00  1.0e+00  0.56
   1    +5.0017500e+03  +2.2498875e+04  2.50e-01 1.25e-01 1.25e-01  5.5e-02  1.11
   2    +3.7962737e+05  +4.0426300e+08  9.49e-04 4.74e-04 4.75e-04  2.1e-04  1.30
   3    +3.9700269e+05  +8.0814760e+12  4.96e-08 2.63e-06 1.02e-06  1.1e-08  1.30
   4    +3.8363686e+05  +1.5380716e+17  2.52e-12 7.59e-07 1.07e-06  5.5e-13  1.30
Solver exited with status Trm_PrimalInfeasible
 Itn              PObj            DObj     PFeas    DFeas    GFeas       Mu  Time
   0    +3.0000000e+00  -2.0000000e+00  1.00e+00 2.00e+00 6.00e+00  1.0e+00  0.00
   1    +1.5189877e+00  +1.4809523e+00  2.11e-02 4.22e-02 1.27e-01  2.1e-02  0.00
   2    +1.5000010e+00  +1.4999990e+00  1.06e-06 2.12e-06 6.36e-06  1.1e-06  0.00
   3    +1.5000000e+00  +1.5000000e+00  5.31e-11 1.06e-10 3.18e-10  5.3e-11  0.00
Solver exited with status Trm_Optimal
 Itn              PObj            DObj     PFeas    DFeas    GFeas       Mu  Time
   0    -2.0000000e+00  +0.0000000e+00  1.00e+00 2.00e+00 1.00e+00  1.0e+00  0.00
   1    -2.9704863e+04  +5.9127473e+02  3.00e-02 6.01e-02 3.00e-02  3.0e-02  0.00
   2    -2.7080006e+06  -2.0092041e+01  8.08e-06 1.62e-05 8.08e-06  8.1e-06  0.00
   3    -5.4159688e+10  -2.0091992e+01  4.04e-10 8.08e-10 4.04e-10  4.0e-10  0.00
Solver exited with status Trm_DualInfeasible
[ Info: used 119 out of 119 precompile statements
All done
```

5. To run the executable from the command line:
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