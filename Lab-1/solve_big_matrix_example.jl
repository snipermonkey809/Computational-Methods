# Example of solving the system from Julia.
#
# Start this BEFORE calling evaluate(n, "your.email@colorado.edu") in Matlab.

using MAT, SparseArrays

# Replace this with your own elimination. The backslash is here only so the
# example runs; it is not allowed in your submission.
mysolve(A, b) = A \ b

# Julia compiles a function the first time it is called, which would otherwise
# happen inside your 30 seconds. Run everything once on a tiny problem first.
#
# Compilation is per argument type, so warm up on the same type you will be
# handed: a dense Matrix for the default pattern, a SparseMatrixCSC for
# 'banded' and 'scattered'. Doing both costs nothing and covers either case.
for A in (rand(2, 2), sparse([1.0 0.0; 0.0 1.0]))
    b = rand(2)
    matwrite("warmup.mat", Dict("x" => reshape(mysolve(A, b), :, 1)))
    matread("warmup.mat")
    rm("warmup.mat")
end

isfile("ready.flag") && rm("ready.flag")   # ignore a flag from a previous run

println("ready and waiting ...")
while !isfile("ready.flag")
    sleep(0.01)
end

A = matread("A.mat")["A"]
b = vec(matread("b.mat")["b"])

x = mysolve(A, b)

matwrite("x.tmp", Dict("x" => reshape(x, :, 1)))
mv("x.tmp", "x.mat", force=true)           # atomic, so evaluate sees it whole

println("wrote x.mat")
