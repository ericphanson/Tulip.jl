const INST_DIR = joinpath(@__DIR__, "../dat/dummy")

include("tulip_cl.jl")

# Read and solve all dummy instances
for finst in ["lpex_inf.mps", "lpex_opt.mps", "lpex_ubd.mps"]
    Tulip_cl.julia_main(["--Threads", "1", "--TimeLimit", "1.0", joinpath(INST_DIR, finst)])
end