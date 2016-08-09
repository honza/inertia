(def shout
  (fn [s]
    (join s "!!!")))

(expose "shout" shout)
