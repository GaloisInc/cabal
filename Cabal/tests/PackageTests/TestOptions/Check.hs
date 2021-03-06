module PackageTests.TestOptions.Check where

import PackageTests.PackageTester
import System.FilePath
import Test.Tasty.HUnit

suite :: FilePath -> Assertion
suite ghcPath = do
    let spec = PackageSpec
            { directory = "PackageTests" </> "TestOptions"
            , configOpts = ["--enable-tests"]
            , distPref = Nothing
            }
    _ <- cabal_build spec ghcPath
    result <- cabal_test spec [] ["--test-options=1 2 3"] ghcPath
    let message = "\"cabal test\" did not pass the correct options to the "
                  ++ "test executable with \"--test-options\""
    assertEqual message True $ successful result
    result' <- cabal_test spec [] [ "--test-option=1"
                                  , "--test-option=2"
                                  , "--test-option=3"
                                  ]
               ghcPath
    let message' = "\"cabal test\" did not pass the correct options to the "
                   ++ "test executable with \"--test-option\""
    assertEqual message' True $ successful result'
