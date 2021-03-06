module PackageTests.BenchmarkOptions.Check where

import PackageTests.PackageTester
import System.FilePath
import Test.Tasty.HUnit

suite :: FilePath -> Assertion
suite ghcPath = do
    let spec = PackageSpec
            { directory = "PackageTests" </> "BenchmarkOptions"
            , configOpts = ["--enable-benchmarks"]
            , distPref = Nothing
            }
    _ <- cabal_build spec ghcPath
    result <- cabal_bench spec ["--benchmark-options=1 2 3"] ghcPath
    let message = "\"cabal bench\" did not pass the correct options to the "
                  ++ "benchmark executable with \"--benchmark-options\""
    assertEqual message True $ successful result
    result' <- cabal_bench spec [ "--benchmark-option=1"
                                , "--benchmark-option=2"
                                , "--benchmark-option=3"
                                ]
               ghcPath
    let message' = "\"cabal bench\" did not pass the correct options to the "
                   ++ "benchmark executable with \"--benchmark-option\""
    assertEqual message' True $ successful result'
