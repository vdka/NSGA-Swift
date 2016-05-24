
[Swiftenv](https://github.com/kylef/swiftenv) installation is highly recommended in order to reduce friction

when installed run the following command to install the latest supported Swift Compiler

```sh
swiftenv install DEVELOPMENT-SNAPSHOT-2016-05-09-a
```

With this done you can now compile Swift code. Run `swift build -c release`. You should see the following:

```
Compile Swift Module 'SwiftPCG' (1 sources)
Compile Swift Module 'NSGA' (20 sources)
Compile CWaterEvaluator constraints.c
Compile CWaterEvaluator evaluator.c
Compile CWaterEvaluator mh_misc.c
Compile CWaterEvaluator misc.c
Compile CWaterEvaluator objectives.c
Linking CWaterEvaluator
Linking .build/release/NSGA
```

When complete your output program is available in `.build/release/` titled `NSGA` and will have file permissions set up for you.

To execute run a command of the following form:

```sh
./.build/release/NSGA $(pwd) seed nGenerations popSize
```

eg.

```sh
./.build/release/NSGA $(pwd) 1BADF00D 99 100
```

This will read datafiles from `./datafiles/` and write output result files to `./results`

## Notes

- Population size must be a multiple of 4 (NSGA limitation)

