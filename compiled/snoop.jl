using LinearAlgebra

import Tulip
TLP = Tulip

BLAS.set_num_threads(1)

# Read and solve all dummy instances
for finst in ["lpex_inf.mps", "lpex_opt.mps", "lpex_ubd.mps"]
    m = Tulip.Model{Float64}()
    TLP.readmps!(m, joinpath(@__DIR__, "../dat/dummy", finst))

    m.env.verbose = true
    TLP.optimize!(m)
end
