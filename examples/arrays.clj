(def a [1 2 3])

(console.log (conj a 4)) ;; [1, 2, 3, 4]
(console.log (cons 0 a)) ;; [0, 1, 2, 3]
(console.log a)          ;; [1, 2, 3]

(console.log (take 2 a)) ;; [1, 2]
(console.log (count a))  ;; 3
(console.log (first a))  ;; 1

(console.log (partition 2 (conj a 4))) ;; [ [1, 2], [3, 4] ]

(def inc
  (fn [x]
    (+ x 1)))

(console.log (map inc a)) ;; [2, 3, 4]
