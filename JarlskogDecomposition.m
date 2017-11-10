BeginPackage["JarlskogDecomposition`"];

Unprotect @@ Names["JarlskogDecomposition`*"];
ClearAll @@ Names["JarlskogDecomposition`*"];
ClearAll @@ Names["JarlskogDecomposition`Private`*"];

ParametrizedUnitary;

Begin["`Private`"];


(*  rowPhaseNormalize takes a matrix and returns the same matrix with the phase
    of each row normalized to make the first element real. In other words, it
    makes the first column of the matrix all real, changing the other elements
    accordingly.
    Returns
    -------
    A two-element list. The first element is the normalized matrix. The second
    element is a diagonal matrix with the phases that were normalized (so that
    multiplying the former with the latter we get the original matrix back).
*)
rowPhaseNormalize[m_] := {
  ReplacePart[m,
    {i_ :> m[[i]] * Exp[-I Arg @ m[[i, 1]]]}
  ] // Chop,
  DiagonalMatrix @ Exp[I Arg @ m[[All, 1]]]
};

(* colPhaseNormalize: as above for columns. *)
colPhaseNormalize[m_] := {
  ReplacePart[m,
    {{i_, j_} :> m[[i, j]] Exp[-I Arg @ m[[1, j]]]}
  ] // Chop,
  DiagonalMatrix @ Exp[I Arg @ m[[1, All]]]
};


gAlpha = Global`\[Alpha];
gBeta = Global`\[Beta];
gTheta = Global`\[Theta];
gDelta = Global`\[Delta];
gGamma = Global`\[Gamma];

(*  aKet
    ----
    Return a parametrized vector of unit norm of the specified length.
    The parametrization used is the standard one used to parametrize the points
    of an n-dimensional sphere.
*)
aKet[n_, delta_: gDelta, gamma_: gGamma] := Append[
  Table[
    Times[
      Apply[Times][
        Sin @ gamma[n, #] & /@ Range[k - 1]
      ],
      Cos @ gamma[n, k],
      If[k > 1, Exp[I delta[n, k]], 1]
    ],
    {k, n - 1}
  ],
  Exp[I delta[n, n]]*Apply[Times][Sin[gamma[n, #]] & /@ Range[n - 1]]
];



unitaryV[1, __] = 1;
unitaryV[n_, theta_ : gTheta, delta_ : gDelta, gamma_ : gGamma] := Module[{
    previousV = unitaryV[n - 1, theta, delta, gamma],
    an, bn,
    m1, m2
  },
  If[n == 2,
    an = {1}; bn = {-1},
    (* otherwise *)
    an = aKet[n - 1, delta, gamma];
    bn = -ConjugateTranspose[previousV] . an
  ];

  an = ArrayReshape[an, {Length @ an, 1}];
  bn = ArrayReshape[bn, {Length @ bn, 1}];
  m1 = ArrayFlatten[
    {
      {
        IdentityMatrix[n - 1] - (1 - Cos @ theta[n]) an . ConjugateTranspose @ an,
        Sin @ theta[n] * an
      },
      {
        -Sin @ theta[n] * ConjugateTranspose @ an,
        Cos @ theta[n]
      }
    }
  ];
  m2 = ArrayFlatten[
    {
      {previousV, 0},
      {0, 1}
    }
  ];
  (* compute and return final result *)
  m1 . m2
];


ParametrizedUnitary[n_Integer, {
    alpha_ : gAlpha, beta_ : gBeta, theta_ : gTheta,
    delta_ : gDelta, gamma_ : gGamma
}] := With[{
    PhiAlpha = DiagonalMatrix @ Exp[I Array[alpha, n]],
    PhiBeta = DiagonalMatrix @ Exp[I Prepend[beta /@ Range[2, n], 0]]
  },
  PhiAlpha . unitaryV[n, theta, delta, gamma] . PhiBeta
];

ParametrizedUnitary[n_Integer] := ParametrizedUnitary[n, {}];


(* Protect all package symbols *)
With[{syms = Names["JarlskogDecomposition`*"]},
  SetAttributes[syms, {Protected, ReadProtected}]
];

End[];
EndPackage[];
