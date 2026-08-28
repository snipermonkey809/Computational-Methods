# `evaluate` — the big matrix leaderboard

`evaluate` generates a random linear system, times how long you take to solve
it, checks your answer, and writes a submission file. Your score is `n`, the
size of the largest system you solve inside the 30 second limit, and it goes on
a leaderboard.

```matlab
evaluate(n, email)           % hand the system off through files (any language)
evaluate(n, email, @solver)  % call your Matlab function directly
```

- `n` is the size of the system.
- `email` is your Gradescope email, as a string in single quotes.
- `@solver` is a handle to your function, e.g. `@gauss`, or another function you write specifically for this purpose.

There is also an optional **pattern** argument, described below, that changes
the kind of matrix you are given and raises the size cap enormously. If you
leave it off you get a dense matrix and the cap is 15000.

Start with a small `n` and work upward. Every call generates a brand new random
system, so an answer from a previous run is of no use.

When a run succeeds, `evaluate` writes `results.json`. **Submit that file to
Gradescope.** Nothing is written if the run fails, so a bad attempt will not
overwrite a good submission.

## Patterns: three kinds of matrix

A dense matrix caps out at 15000 because that is all that fits in the file
format. A matrix that is mostly zeros stores far more equations in the same
space — but only if your solver knows not to waste time on the zeros. Pass a
pattern name to pick one:

```matlab
evaluate(n, email, 'banded')
evaluate(n, email, @solver, 'scattered')   % the two optional arguments may
evaluate(n, email, 'scattered', @solver)   % appear in either order
```

| pattern | structure | largest `n` |
| --- | --- | --- |
| `'dense'` (the default) | every entry nonzero | 15000 |
| `'banded'` | nonzeros only within 100 of the diagonal | 600000 |
| `'scattered'` | about 10 nonzeros per row, in random positions | 10500000 |

Every cap is the same wall: the `.mat` format cannot store a variable of 2 GB
or more. Nothing else is holding them down, so if you are stopping short of the
cap it is your solver, not the harness.

The quickest way to see what you are dealing with is to generate a small one
and look at it:

```matlab
evaluate(200, email, @solve_big_matrix, 'banded')
load('A.mat')
spy(A)
```

`A.mat` is left behind after a run, so it does not matter whether your solver
succeeded. `spy` plots one dot per nonzero. Do this once for each pattern at
n = 200 or so and the structure you need to exploit is immediately obvious.

All three are scored on the same leaderboard, so a pattern you can solve at a
larger `n` is worth more. They reward completely different ideas, and the one
that is easiest for you depends on what you are willing to write.

For the sparse patterns `A` arrives as a **sparse matrix**, not a full one.
Two warnings about that:

- **`full(A)` throws away the whole advantage** and, past about n = 15000, will
  not fit in memory at all.
- **Sparse storage by itself makes naive code slower, not faster.** Matlab
  stores a sparse matrix by columns, so the row operations in ordinary Gaussian
  elimination become very expensive. Running unmodified `gauss_pivot` on a
  banded `n = 1000` matrix takes about 60 times *longer* than running it on the
  same matrix stored densely. Sparsity is a saving in space; the saving in time
  only arrives when your algorithm stops visiting the zeros.

Both sparse patterns are well conditioned, so an accurate answer is available
in each. Neither needs pivoting.

## Solving in Matlab

Write a function that takes `A` and `b` and returns `x`:

```matlab
function x = solve_big_matrix(A, b)
    x = gauss_pivot(A, b);
end
```

Then hand it to `evaluate`:

```matlab
evaluate(1000, 'your.gradescope.email@colorado.edu', @solve_big_matrix)
```

`evaluate` writes the system to `A.mat` and `b.mat`, reads it back in, times
your function, and checks the answer. It reads the files back rather than
passing them straight to you so that the Matlab route is charged exactly the
same work as the file route below.

## Solving in another language

Call `evaluate` with two arguments and it hands the system off through files:

```matlab
evaluate(1000, 'your.gradescope.email@colorado.edu')
```

The sequence is:

1. Start your program **first**. Have it wait for `ready.flag` to appear.
2. In Matlab, call `evaluate(n, 'your.email@colorado.edu')`.
3. `evaluate` writes `A.mat` and `b.mat`, closes them, then creates
   `ready.flag`. **The 30 seconds start here.**
4. Your program sees `ready.flag`, reads `A.mat` and `b.mat`, and solves.
5. Your program writes the answer to `x.tmp`, then renames it to `x.mat`.
6. `evaluate` picks up `x.mat`, stops the clock, and checks the answer.

All of these files live in Matlab's current folder, so run your program from
that same directory.

### Two rules that matter

**Wait for `ready.flag`, not for `A.mat`.** `A.mat` appears the instant Matlab
starts writing it, which for a large system is well before the file is
complete — at `n = 6000` it shows up empty and takes about a tenth of a second
to fill, and it only gets worse as `n` grows. Poll for `A.mat` and you will read
a truncated file and get an error that looks like a bug in your own code.
`ready.flag` is created only after both data files are closed.

**Write `x.tmp`, then rename it to `x.mat`.** The same hazard in reverse:
`evaluate` polls for `x.mat` and could catch it half written. Renaming is
atomic, so the complete answer appears in one step. Never write directly to
`x.mat`.

### Reading and writing the files

The files are Matlab v6 `.mat`. In Julia use `MAT.jl`; in Python use
`scipy.io.loadmat` and `savemat`. `solve_big_matrix_example.jl` is a complete
working example of the Julia side.

For `'banded'` and `'scattered'`, `A` comes back as a sparse matrix in whatever
your language calls it — a `SparseMatrixCSC` in Julia, a `csc_matrix` in
Python. Write `x` as a plain dense column either way.

## Watch the clock

The 30 seconds start when `ready.flag` appears and stop when `evaluate` reads a
complete `x.mat`. Reading `A.mat` and writing `x.mat` are inside that window —
they are for Matlab solutions too, so this is not a handicap.

Interpreter startup is *not* free. If you launch your program after calling
`evaluate`, the time your language takes to start counts against you. Start it
ahead of time and let it sit in the wait loop.

For Julia, being already running is **not enough**. Julia compiles each function
the first time it is called, and the functions that read the files and solve the
system do not run until after the wait loop — so the compilation lands squarely
inside your 30 seconds. On an 800 x 800 system this cost 9.95 seconds, a third
of the budget, for a solve that actually takes a fifth of a second. Do one
throwaway solve on a tiny matrix before the wait loop and the same run takes
0.21 seconds. `solve_big_matrix_example.jl` shows the pattern.

Warm up on a matrix of the **same type** you will actually be given. Julia
compiles separately for a dense `Matrix` and a `SparseMatrixCSC`, so warming up
on a dense matrix and then being handed a sparse one puts the compilation right
back inside your 30 seconds.

## If something goes wrong

| Message | Likely cause |
| --- | --- |
| Error reading `A.mat`, or it looks empty | You polled for `A.mat` instead of `ready.flag` |
| `No usable x.mat appeared within 30 seconds` | Your program did not finish, did not write `x.mat`, or wrote it elsewhere |
| `x has N entries, but it should have M` | Wrong shape — write `x` as a single column |
| `That is not accurate enough` | Your solver returned a wrong answer, or read a truncated `A.mat`; for `'scattered'`, an iterative method that stopped too early |
| `Expected n to be ... <= 15000` | That is the dense cap — pass a pattern name to go bigger |
| `That is over the 30 second limit` | Try a smaller `n`, and make sure your program was already waiting |
| `Your solver threw an error` | The error from your own function is printed with it |
