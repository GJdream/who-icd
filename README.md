who-icd
=======

Proof of concept to load the root ICD10 codes from WHO with RestKit (without PathPattern sadly) into a UITableView while stripping out all that nonsense formatting code.

*Note:* need to run CocoaPods "pod install" prior to build and then load the .xcworkspace.

*Turns this:*

```[741][hall.qp0340kydnp: tmp]$ curl http://apps.who.int/classifications/icd10/browse/2010/en/JsonGetRootConcepts 
  [{"ID":"I","html":"\r\n\r\n\u003ca class=\"ygtvlabel \"  href=\"#/I\" \u003e \r\n    \r\n\r\n\r\nCertain infectious and parasitic diseases\r\n\r\n  \r\n\u003c/a\u003e\u0026nbsp;","isLeaf":false,"isAdoptedChild":false,"UseDiffViewMode":true},{"ID":"II","html":"\r\n\r\n\u003ca class=\"ygtvlabel \"  href=\"#/II\" \u003e \r\n    \r\n\r\n\r\nNeoplasms\r\n\r\n    \r\n\u003c/a\u003e\u0026nbsp;","isLeaf":false,"isAdoptedChild":false,"UseDiffViewMode":true},...```

Into this:
  ![UITableView Image](README/icdTableView.png)