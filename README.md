# JarlskogDecomposition

This is a simple implementation of the parametrization of an arbitrary unitary matrix proposed in [Jarlskog (2015)](https://arxiv.org/abs/math-ph/0504049).

The package exposes the single function `ParametrizedUnitary`, which takes a single integer argument and returns the corresponding parametrized unitary.
A second optional argument can be used to have the output matrix use different symbols for parameters.

## Installation
The simplest way to install this package is to evaluate the following (code adapted from the [MaTeX readme page](https://github.com/szhorvat/MaTeX)):

```Mathematica
Module[{json, download, target},
  Check[
    json = Import["https://api.github.com/repos/lucainnocenti/JarlskogDecomposition/releases/latest", "JSON"];
    download = Lookup[First@Lookup[json, "assets"], "browser_download_url"];
    target = FileNameJoin[{CreateDirectory[], "JarlskogDecomposition.paclet"}];
    If[$Notebooks,
      PrintTemporary @ Labeled[ProgressIndicator[Appearance -> "Necklace"], "Downloading...", Right],
      Print["Downloading..."]
    ];
    URLSave[download, target],
    Return[$Failed]
  ];
  If[FileExistsQ[target], PacletInstall[target], $Failed]
]
```
After this, just evaluate ``Needs["JarlskogDecomposition`"]`` in a notebook to use it.

If you later want to uninstall the package, just run `PacletUninstall["JarlskogDecomposition"]`.
