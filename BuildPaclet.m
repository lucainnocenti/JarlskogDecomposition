SetDirectory @ NotebookDirectory[];
filesToPack = {
  "JarlskogDecomposition.m",
  "PacletInfo.m",
  "README.md"
};
dir = CreateDirectory[];
Do[
  CopyFile[
    file,
    FileNameJoin @ {dir, file}
  ],
  {file, filesToPack}
];
pacletPath = PackPaclet @ dir;
CopyFile[pacletPath, FileNameTake @ pacletPath, OverwriteTarget -> True]
