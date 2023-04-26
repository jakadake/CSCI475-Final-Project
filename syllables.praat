kg_a = Create KlattGrid: "a", 0, 0.110, 6, 1, 1, 6, 1, 1, 1

Add flutter point: 0, 0.25

# 'A'
selectObject: kg_a
Add pitch point: 0, 114
Add voicing amplitude point: 0, 80

Add frication amplitude point: 0, 5
Add frication bypass point: 0.5, 0

Add oral formant frequency point: 1, 0, 741
Add oral formant bandwidth point: 1, 0, 137

Add oral formant frequency point: 2, 0, 1283
Add oral formant bandwidth point: 2, 0, 147

Add oral formant frequency point: 3, 0, 2459
Add oral formant bandwidth point: 3, 0, 277

Add oral formant frequency point: 4, 0, 3906
Add oral formant bandwidth point: 4, 0, 751

# 'S'
kg_sa = Create KlattGrid: "sa", 0, 0.243, 6, 1, 1, 6, 1, 1, 1
selectObject: kg_sa
Add pitch point: 0, 117
Add voicing amplitude point: 0, 0

Add frication amplitude point: 0, 150
Add frication bypass point: 0.5, 0

Add oral formant frequency point: 1, 0, 831
Add oral formant bandwidth point: 1, 0, 83

Add oral formant frequency point: 2, 0, 1744
Add oral formant bandwidth point: 2, 0, 506

Add oral formant frequency point: 3, 0, 2757
Add oral formant bandwidth point: 3, 0, 799

Add oral formant frequency point: 4, 0, 3830
Add oral formant bandwidth point: 4, 0, 916

Add voicing amplitude point: 0.103, 0
Add frication amplitude point: 0.103, 150

#'A'
Add pitch point: 0.258, 124
Add voicing amplitude point: 0.152, 83

Add frication amplitude point: 0.152, 5
Add frication bypass point: 0.5, 0.152

Add oral formant frequency point: 1, 0.152, 675
Add oral formant bandwidth point: 1, 0.152, 69

Add oral formant frequency point: 2, 0.152, 1220
Add oral formant bandwidth point: 2, 0.152, 119

Add oral formant frequency point: 3, 0.152, 2542
Add oral formant bandwidth point: 3, 0.152, 567

Add oral formant frequency point: 4, 0.152, 3705
Add oral formant bandwidth point: 4, 0.152, 936

# 'M'
kg_ma = Create KlattGrid: "ma", 0, 0.209, 6, 1, 1, 6, 1, 1, 1
selectObject: kg_ma
Add pitch point: 0, 125
Add voicing amplitude point: 0, 78

Add frication amplitude point: 0, 5
Add frication bypass point: 0.5, 0

Add oral formant frequency point: 1, 0, 647
Add oral formant bandwidth point: 1, 0, 824

Add oral formant frequency point: 2, 0, 1085
Add oral formant bandwidth point: 2, 0, 511

Add oral formant frequency point: 3, 0, 2747
Add oral formant bandwidth point: 3, 0, 880

Add oral formant frequency point: 4, 0, 3742
Add oral formant bandwidth point: 4, 0, 3317

# 'A'
Add pitch point: 0.115, 130
Add voicing amplitude point: 0.115, 82

Add frication amplitude point: 0.115, 5
Add frication bypass point: 0.5, 0.115

Add oral formant frequency point: 1, 0.115, 683
Add oral formant bandwidth point: 1, 0.115, 106

Add oral formant frequency point: 2, 0.115, 1185
Add oral formant bandwidth point: 2, 0.115, 110

Add oral formant frequency point: 3, 0.115, 2610
Add oral formant bandwidth point: 3, 0.115, 656

Add oral formant frequency point: 4, 0.115, 3364
Add oral formant bandwidth point: 4, 0.115, 601

# 'L'
kg_la = Create KlattGrid: "la", 0, 0.122, 6, 1, 1, 6, 1, 1, 1
selectObject: kg_la
Add pitch point: 0, 127
Add voicing amplitude point: 0, 82

Add frication amplitude point: 0, 5
Add frication bypass point: 0.5, 0.558

Add oral formant frequency point: 1, 0, 567
Add oral formant bandwidth point: 1, 0, 94

Add oral formant frequency point: 2, 0, 1110
Add oral formant bandwidth point: 2, 0, 182

Add oral formant frequency point: 3, 0, 2618
Add oral formant bandwidth point: 3, 0, 287

Add oral formant frequency point: 4, 0, 3831
Add oral formant bandwidth point: 4, 0, 785

# 'A'
Add pitch point: 0.039, 122
Add voicing amplitude point: 0.039, 82

Add frication amplitude point: 0.039, 5
Add frication bypass point: 0.5, 0.039

Add oral formant frequency point: 1, 0.039, 690
Add oral formant bandwidth point: 1, 0.039, 39

Add oral formant frequency point: 2, 0.039, 1172
Add oral formant bandwidth point: 2, 0.039, 144

Add oral formant frequency point: 3, 0.039, 2490
Add oral formant bandwidth point: 3, 0.039, 287

Add oral formant frequency point: 4, 0.039, 3679
Add oral formant bandwidth point: 4, 0.039, 785

selectObject: kg_a, kg_sa, kg_ma, kg_la

To Sound

chain = Concatenate