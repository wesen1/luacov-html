* FileSystemEntry:calculatePathDirectoryCoverages() => Cache after calculating once
* FileSystemEntry:calculateFullPath() => Cache


integration tests:

* TotalCoverageData manually fill
  - Check that directories are created as expected
  - Check that directory paths are expected paths
  - Check that coverage data per directory and file is as expected



mach: `may_be_called():any_number_of_times()`

My solution for now was: `may_be_called():multiple_times(10)` with a high enough number

-> TestFile + TestFileSystemEntryCollection
